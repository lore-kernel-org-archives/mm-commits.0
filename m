Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA50F33E1
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 05:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746335725; cv=none; b=EOZQ9DjcrnB7Ci3MrElCxzyc+TkpTq67y7ZAN8oVo/+rHdnWDf0cbkAMp9HFmtXGUmn8TATVwtxyTOC4T02nSMCp8I25WKQfssN9pGpLNCWOeSFROJug5yD54svDfLJSN+DssLcoKGiVtTB7+Yq7bbSqcOYiJYTmBhA21wlYRhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746335725; c=relaxed/simple;
	bh=ChKAAWZAm/rqM44bH88P8n02BfsYRHy1FU6Zwt/r4TA=;
	h=Date:To:From:Subject:Message-Id; b=uQpvoqE4gcAT5+cXqQdEy9BMrIVpAKZBihiAyjIV5OQ8vIWO6kt+AJ06uxs5HicFr2v7j4nWUO1m1zKBk9LeZprzepVmKykxAPLKsfspr+h1JaLhjycntu3f6gVko9s4dKYlV84EVbsjglvhKDwVrk8z0W6iI3cz0Mrl4OVvNHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NT6yYwSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NT6yYwSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C164C4CEED;
	Sun,  4 May 2025 05:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746335725;
	bh=ChKAAWZAm/rqM44bH88P8n02BfsYRHy1FU6Zwt/r4TA=;
	h=Date:To:From:Subject:From;
	b=NT6yYwSGgTDlBadsVpPHdncCxksgEMVBzD0e8+NrgSz+wcU2fR/wS/Ub5oT4gkVTS
	 mvh5DVTFK/iXpcTHriDiSnf1HnOV6PRiWcal647B+hk0AdSU3pl+kVuwf81CkeDXi7
	 Wwwaf0b9hqHA1RWIN5qQEXHfbuuSnl5EMSUyJUv4=
Date: Sat, 03 May 2025 22:15:24 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,bhe@redhat.com,berrange@redhat.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging.patch added to mm-nonmm-unstable branch
Message-Id: <20250504051525.0C164C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_dump: reuse saved dm crypt keys for CPU/memory hot-plugging
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging.patch

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
From: Coiby Xu <coxu@redhat.com>
Subject: crash_dump: reuse saved dm crypt keys for CPU/memory hot-plugging
Date: Fri, 2 May 2025 09:12:38 +0800

When there are CPU and memory hot un/plugs, the dm crypt keys may need to
be reloaded again depending on the solution for crash hotplug support. 
Currently, there are two solutions.  One is to utilizes udev to instruct
user space to reload the kdump kernel image and initrd, elfcorehdr and etc
again.  The other is to only update the elfcorehdr segment introduced in
commit 247262756121 ("crash: add generic infrastructure for crash hotplug
support").

For the 1st solution, the dm crypt keys need to be reloaded again.  The
user space can write true to /sys/kernel/config/crash_dm_crypt_key/reuse
so the stored keys can be re-used.

For the 2nd solution, the dm crypt keys don't need to be reloaded. 
Currently, only x86 supports the 2nd solution.  If the 2nd solution gets
extended to all arches, this patch can be dropped.

Link: https://lkml.kernel.org/r/20250502011246.99238-5-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jan Pazdziora <jpazdziora@redhat.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    4 +
 kernel/crash_dump_dm_crypt.c              |   52 ++++++++++++++++++--
 2 files changed, 52 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/kdump/kdump.rst~crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -570,6 +570,10 @@ encrypted disk volume. User space can in
     cat /sys/kernel/config/crash_dm_crypt_keys/count
     2
 
+    # To support CPU/memory hot-plugging, re-use keys already saved to reserved
+    # memory
+    echo true > /sys/kernel/config/crash_dm_crypt_key/reuse
+
 2. Load the dump-capture kernel
 
 3. After the dump-capture kerne get booted, restore the keys to user keyring
--- a/kernel/crash_dump_dm_crypt.c~crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging
+++ a/kernel/crash_dump_dm_crypt.c
@@ -28,6 +28,20 @@ static size_t get_keys_header_size(size_
 	return struct_size(keys_header, keys, total_keys);
 }
 
+static void get_keys_from_kdump_reserved_memory(void)
+{
+	struct keys_header *keys_header_loaded;
+
+	arch_kexec_unprotect_crashkres();
+
+	keys_header_loaded = kmap_local_page(pfn_to_page(
+		kexec_crash_image->dm_crypt_keys_addr >> PAGE_SHIFT));
+
+	memcpy(keys_header, keys_header_loaded, get_keys_header_size(key_count));
+	kunmap_local(keys_header_loaded);
+	arch_kexec_protect_crashkres();
+}
+
 static int read_key_from_user_keying(struct dm_crypt_key *dm_key)
 {
 	const struct user_key_payload *ukp;
@@ -150,8 +164,36 @@ static ssize_t config_keys_count_show(st
 
 CONFIGFS_ATTR_RO(config_keys_, count);
 
+static bool is_dm_key_reused;
+
+static ssize_t config_keys_reuse_show(struct config_item *item, char *page)
+{
+	return sprintf(page, "%d\n", is_dm_key_reused);
+}
+
+static ssize_t config_keys_reuse_store(struct config_item *item,
+					   const char *page, size_t count)
+{
+	if (!kexec_crash_image || !kexec_crash_image->dm_crypt_keys_addr) {
+		kexec_dprintk(
+			"dm-crypt keys haven't be saved to crash-reserved memory\n");
+		return -EINVAL;
+	}
+
+	if (kstrtobool(page, &is_dm_key_reused))
+		return -EINVAL;
+
+	if (is_dm_key_reused)
+		get_keys_from_kdump_reserved_memory();
+
+	return count;
+}
+
+CONFIGFS_ATTR(config_keys_, reuse);
+
 static struct configfs_attribute *config_keys_attrs[] = {
 	&config_keys_attr_count,
+	&config_keys_attr_reuse,
 	NULL,
 };
 
@@ -238,10 +280,12 @@ int crash_load_dm_crypt_keys(struct kima
 		return -ENOENT;
 	}
 
-	image->dm_crypt_keys_addr = 0;
-	r = build_keys_header();
-	if (r)
-		return r;
+	if (!is_dm_key_reused) {
+		image->dm_crypt_keys_addr = 0;
+		r = build_keys_header();
+		if (r)
+			return r;
+	}
 
 	kbuf.buffer = keys_header;
 	kbuf.bufsz = get_keys_header_size(key_count);
_

Patches currently in -mm which might be from coxu@redhat.com are

kexec_file-allow-to-place-kexec_buf-randomly.patch
crash_dump-make-dm-crypt-keys-persist-for-the-kdump-kernel.patch
crash_dump-store-dm-crypt-keys-in-kdump-reserved-memory.patch
crash_dump-reuse-saved-dm-crypt-keys-for-cpu-memory-hot-plugging.patch
crash_dump-retrieve-dm-crypt-keys-in-kdump-kernel.patch
revert-x86-mm-remove-unused-__set_memory_prot.patch
x86-crash-pass-dm-crypt-keys-to-kdump-kernel.patch
x86-crash-make-the-page-that-stores-the-dm-crypt-keys-inaccessible.patch

