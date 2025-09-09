Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83B918871F;
	Tue,  9 Sep 2025 04:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757391338; cv=none; b=mErGoOybuqZJTaEWMIK0RhYGj+xMcN23bgIs6GFQ0oEUVUX5KcgdmKp3S8jCtrBF6LZEp80epjvSV7j53zqj+22ePCCBg45hp2lZoTgwAcbfnDUfowvof8rZ1osirFIaeuFZJmiQVmS6bYjgMXHX1u436CDwb8wLkb9H3CGwmDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757391338; c=relaxed/simple;
	bh=wgDYj57Ma1O4p0xWYT+j0iFwPFFRunbDk1F8pfPvnMQ=;
	h=Date:To:From:Subject:Message-Id; b=stFsNwvlrfuGKiIfRGFAbn0aNjV9xJcJAc3R3h16SFXG3uDaoF/fISVeZPyDpztcFcIrVB50mORP7PBGmVopmITz7kTJJGyqeSxHcY8tU6xCiwqQnGxXZ5jac8T7WUV76zJ9Mega8FgTjHeoU1ZVECRmdBd3I2fK/oA5BlRYgkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E4DE/VMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E4DE/VMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1581CC4CEF4;
	Tue,  9 Sep 2025 04:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757391338;
	bh=wgDYj57Ma1O4p0xWYT+j0iFwPFFRunbDk1F8pfPvnMQ=;
	h=Date:To:From:Subject:From;
	b=E4DE/VMNDY6uCOsCdm+2vb90+RzgBEm84Rfpn6gP1qlo/5YWrulNap/PZiTR0H5r2
	 W/mPXVnB2AgYbZ0yRCti/VzanBR7g2ukQpU4IQyVGue69vnYPvcuzzxXt8jZ2dS0Ok
	 zZ7MdnI5dNsR+YcyLK22xoLtthSFHxnG+lrjmJnI=
Date: Mon, 08 Sep 2025 21:15:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,oliver.sang@intel.com,konishi.ryusuke@gmail.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-cfi-failure-when-accessing-sys-fs-nilfs2-features.patch added to mm-hotfixes-unstable branch
Message-Id: <20250909041538.1581CC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix CFI failure when accessing /sys/fs/nilfs2/features/*
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-cfi-failure-when-accessing-sys-fs-nilfs2-features.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-cfi-failure-when-accessing-sys-fs-nilfs2-features.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: nilfs2: fix CFI failure when accessing /sys/fs/nilfs2/features/*
Date: Sat, 6 Sep 2025 23:43:34 +0900

When accessing one of the files under /sys/fs/nilfs2/features when
CONFIG_CFI_CLANG is enabled, there is a CFI violation:

  CFI failure at kobj_attr_show+0x59/0x80 (target: nilfs_feature_revision_show+0x0/0x30; expected type: 0xfc392c4d)
  ...
  Call Trace:
   <TASK>
   sysfs_kf_seq_show+0x2a6/0x390
   ? __cfi_kobj_attr_show+0x10/0x10
   kernfs_seq_show+0x104/0x15b
   seq_read_iter+0x580/0xe2b
  ...

When the kobject of the kset for /sys/fs/nilfs2 is initialized, its ktype
is set to kset_ktype, which has a ->sysfs_ops of kobj_sysfs_ops.  When
nilfs_feature_attr_group is added to that kobject via
sysfs_create_group(), the kernfs_ops of each files is sysfs_file_kfops_rw,
which will call sysfs_kf_seq_show() when ->seq_show() is called. 
sysfs_kf_seq_show() in turn calls kobj_attr_show() through
->sysfs_ops->show().  kobj_attr_show() casts the provided attribute out to
a 'struct kobj_attribute' via container_of() and calls ->show(), resulting
in the CFI violation since neither nilfs_feature_revision_show() nor
nilfs_feature_README_show() match the prototype of ->show() in 'struct
kobj_attribute'.

Resolve the CFI violation by adjusting the second parameter in
nilfs_feature_{revision,README}_show() from 'struct attribute' to 'struct
kobj_attribute' to match the expected prototype.

Link: https://lkml.kernel.org/r/20250906144410.22511-1-konishi.ryusuke@gmail.com
Fixes: aebe17f68444 ("nilfs2: add /sys/fs/nilfs2/features group")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202509021646.bc78d9ef-lkp@intel.com/
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    4 ++--
 fs/nilfs2/sysfs.h |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/sysfs.c~nilfs2-fix-cfi-failure-when-accessing-sys-fs-nilfs2-features
+++ a/fs/nilfs2/sysfs.c
@@ -1075,7 +1075,7 @@ void nilfs_sysfs_delete_device_group(str
  ************************************************************************/
 
 static ssize_t nilfs_feature_revision_show(struct kobject *kobj,
-					    struct attribute *attr, char *buf)
+					    struct kobj_attribute *attr, char *buf)
 {
 	return sysfs_emit(buf, "%d.%d\n",
 			NILFS_CURRENT_REV, NILFS_MINOR_REV);
@@ -1087,7 +1087,7 @@ static const char features_readme_str[]
 	"(1) revision\n\tshow current revision of NILFS file system driver.\n";
 
 static ssize_t nilfs_feature_README_show(struct kobject *kobj,
-					 struct attribute *attr,
+					 struct kobj_attribute *attr,
 					 char *buf)
 {
 	return sysfs_emit(buf, features_readme_str);
--- a/fs/nilfs2/sysfs.h~nilfs2-fix-cfi-failure-when-accessing-sys-fs-nilfs2-features
+++ a/fs/nilfs2/sysfs.h
@@ -50,16 +50,16 @@ struct nilfs_sysfs_dev_subgroups {
 	struct completion sg_segments_kobj_unregister;
 };
 
-#define NILFS_COMMON_ATTR_STRUCT(name) \
+#define NILFS_KOBJ_ATTR_STRUCT(name) \
 struct nilfs_##name##_attr { \
 	struct attribute attr; \
-	ssize_t (*show)(struct kobject *, struct attribute *, \
+	ssize_t (*show)(struct kobject *, struct kobj_attribute *, \
 			char *); \
-	ssize_t (*store)(struct kobject *, struct attribute *, \
+	ssize_t (*store)(struct kobject *, struct kobj_attribute *, \
 			 const char *, size_t); \
 }
 
-NILFS_COMMON_ATTR_STRUCT(feature);
+NILFS_KOBJ_ATTR_STRUCT(feature);
 
 #define NILFS_DEV_ATTR_STRUCT(name) \
 struct nilfs_##name##_attr { \
_

Patches currently in -mm which might be from nathan@kernel.org are

compiler-clangh-define-__sanitize___-macros-only-when-undefined.patch
nilfs2-fix-cfi-failure-when-accessing-sys-fs-nilfs2-features.patch
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level-fix.patch

