Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB78215C69
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 23:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848669; cv=none; b=fyxb3xMAHlcsladl+RaoaAb1KzK8CTTRQtKi2pbwaKnXP/qPwIaGe8i6+q3SvtCHOy/D/pS7L5yGeINPe+pUSQw/ofYwpzf+XlGx6ndlT/n147bLnnyH+RS8KPuiD0a4vHUcmTzqkNMZW2gi6EaKOfARfv4+MRgAOtRD8WtQQlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848669; c=relaxed/simple;
	bh=e/V6JBXFfjQ07XcU+u0+QAOSrWHgYIGii/ms+Nsi9yE=;
	h=Date:To:From:Subject:Message-Id; b=ZA7Ex/zubMDJUuQXdetq6YKBDfTVshSD+gb+lWFbvx7mBQAGwYBKw60YuCYGV2fAxQ6M4sdRtkjnM7LjeyD64oE8ycz9FTy2h5Y7+vHGWldQLTOIwK7sQCqIODBTcWcQDa8GexjBTmWu7q6abkdEJllER1MzZbEP4QIyPC/Eom4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tK9xP33k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tK9xP33k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311F7C4CECF;
	Tue,  5 Nov 2024 23:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730848669;
	bh=e/V6JBXFfjQ07XcU+u0+QAOSrWHgYIGii/ms+Nsi9yE=;
	h=Date:To:From:Subject:From;
	b=tK9xP33kMOK/ogJUCEZkSokzz8QDfl+KXt4vhWn/kWK1CKfudeiQVoLnlrrgyivGR
	 5WvxIU2Ao1tr/qzrtE1V2vsJWuc5iF28QA8vt4AmzhuXRAtUnml8/1mtBkKrCMyZRF
	 YE1IcqK9qU55/GBeglb25nlelJzZPTFmxD5jsIzQ=
Date: Tue, 05 Nov 2024 15:17:48 -0800
To: mm-commits@vger.kernel.org,linux@weissschuh.net,joel.granados@kernel.org,festevam@denx.de,daniel.lezcano@linaro.org,zhangguopeng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-reboot-replace-sprintf-with-sysfs_emit.patch added to mm-nonmm-unstable branch
Message-Id: <20241105231749.311F7C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/reboot: replace sprintf() with sysfs_emit()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-reboot-replace-sprintf-with-sysfs_emit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-reboot-replace-sprintf-with-sysfs_emit.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: zhangguopeng <zhangguopeng@kylinos.cn>
Subject: kernel/reboot: replace sprintf() with sysfs_emit()
Date: Tue, 5 Nov 2024 17:49:41 +0800

As Documentation/filesystems/sysfs.rst suggested, show() should only use
sysfs_emit() or sysfs_emit_at() when formatting the value to be returned
to user space.

No functional change intended.

Link: https://lkml.kernel.org/r/20241105094941.33739-1-zhangguopeng@kylinos.cn
Signed-off-by: zhangguopeng <zhangguopeng@kylinos.cn>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/reboot.c~kernel-reboot-replace-sprintf-with-sysfs_emit
+++ a/kernel/reboot.c
@@ -1137,7 +1137,7 @@ static ssize_t mode_show(struct kobject
 		val = REBOOT_UNDEFINED_STR;
 	}
 
-	return sprintf(buf, "%s\n", val);
+	return sysfs_emit(buf, "%s\n", val);
 }
 static ssize_t mode_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
@@ -1167,7 +1167,7 @@ static struct kobj_attribute reboot_mode
 #ifdef CONFIG_X86
 static ssize_t force_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", reboot_force);
+	return sysfs_emit(buf, "%d\n", reboot_force);
 }
 static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
@@ -1214,7 +1214,7 @@ static ssize_t type_show(struct kobject
 		val = REBOOT_UNDEFINED_STR;
 	}
 
-	return sprintf(buf, "%s\n", val);
+	return sysfs_emit(buf, "%s\n", val);
 }
 static ssize_t type_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
@@ -1247,7 +1247,7 @@ static struct kobj_attribute reboot_type
 #ifdef CONFIG_SMP
 static ssize_t cpu_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", reboot_cpu);
+	return sysfs_emit(buf, "%d\n", reboot_cpu);
 }
 static ssize_t cpu_store(struct kobject *kobj, struct kobj_attribute *attr,
 			  const char *buf, size_t count)
_

Patches currently in -mm which might be from zhangguopeng@kylinos.cn are

mm-memory-failure-replace-sprintf-with-sysfs_emit.patch
kernel-reboot-replace-sprintf-with-sysfs_emit.patch

