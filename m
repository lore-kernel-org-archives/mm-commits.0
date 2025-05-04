Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C4F33E1
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 05:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746335716; cv=none; b=QJgKfKRC1Xw7ByeWTZdugOJ6XwRQ5NaKTNuCejS9Vf4aG3wvMAYgb2oVz9LmC7vojqJV6BAfNcx6q/rqiGesZQ0Y2hJsfgrBhtbrvoXd4s2U9JHx8JPhUEN+8e+C0h5utlN2OCsYCPbl9BB6QDrix4ijlETxtfu2PngvpXoKzvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746335716; c=relaxed/simple;
	bh=ncoqsc+B9hCYZF1mJwzMbUuBm5sG/ICOW/UPBoKshN8=;
	h=Date:To:From:Subject:Message-Id; b=hrfEiB7rYPNHjnijE/rr18NQl2DFJmbwUpMyPLbg5LYKfM9OIC5QDu0XkVxwhYSA5X6WmPzAo1aSdWgRp434JUuoqzBujdCkYwZjtfmQO9Kls4N+sqg4lwnVSPbqQJY9S+5ZR1b6l6Ap+N9yQQqSweZR2Elhh9h26BlwPv9E7as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GwR4QUU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GwR4QUU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD8CC4CEED;
	Sun,  4 May 2025 05:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746335715;
	bh=ncoqsc+B9hCYZF1mJwzMbUuBm5sG/ICOW/UPBoKshN8=;
	h=Date:To:From:Subject:From;
	b=GwR4QUU2nTP/CmW88fv9LtMnIq8y6/MV1lVZPaap2Cq0kEbcQOVmX2iC+myU41pTq
	 31AAJeGelASzmh8esKAmIKtQmCSACJYQ2Pb9cSQ//9oFfOtksLrkk910/aGiFH+nyL
	 nN9YHXrWE7zChMarbfLzixGsfwOC3Nzvt4i7ZAa0=
Date: Sat, 03 May 2025 22:15:15 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,bhe@redhat.com,berrange@redhat.com,coxu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-allow-to-place-kexec_buf-randomly.patch added to mm-nonmm-unstable branch
Message-Id: <20250504051515.BBD8CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_file: allow to place kexec_buf randomly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_file-allow-to-place-kexec_buf-randomly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-allow-to-place-kexec_buf-randomly.patch

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
Subject: kexec_file: allow to place kexec_buf randomly
Date: Fri, 2 May 2025 09:12:35 +0800

Patch series "Support kdump with LUKS encryption by reusing LUKS volume
keys", v9.

LUKS is the standard for Linux disk encryption, widely adopted by users,
and in some cases, such as Confidential VMs, it is a requirement.  With
kdump enabled, when the first kernel crashes, the system can boot into the
kdump/crash kernel to dump the memory image (i.e., /proc/vmcore) to a
specified target.  However, there are two challenges when dumping vmcore
to a LUKS-encrypted device:

 - Kdump kernel may not be able to decrypt the LUKS partition. For some
   machines, a system administrator may not have a chance to enter the
   password to decrypt the device in kdump initramfs after the 1st kernel
   crashes; For cloud confidential VMs, depending on the policy the
   kdump kernel may not be able to unseal the keys with TPM and the
   console virtual keyboard is untrusted.

 - LUKS2 by default use the memory-hard Argon2 key derivation function
   which is quite memory-consuming compared to the limited memory reserved
   for kdump. Take Fedora example, by default, only 256M is reserved for
   systems having memory between 4G-64G. With LUKS enabled, ~1300M needs
   to be reserved for kdump. Note if the memory reserved for kdump can't
   be used by 1st kernel i.e. an user sees ~1300M memory missing in the
   1st kernel.

Besides users (at least for Fedora) usually expect kdump to work out of
the box i.e.  no manual password input or custom crashkernel value is
needed.  And it doesn't make sense to derivate the keys again in kdump
kernel which seems to be redundant work.

This patchset addresses the above issues by making the LUKS volume keys
persistent for kdump kernel with the help of cryptsetup's new APIs
(--link-vk-to-keyring/--volume-key-keyring).  Here is the life cycle of
the kdump copies of LUKS volume keys,

 1. After the 1st kernel loads the initramfs during boot, systemd
    use an user-input passphrase to de-crypt the LUKS volume keys
    or TPM-sealed key and then save the volume keys to specified keyring
    (using the --link-vk-to-keyring API) and the key will expire within
    specified time.

 2. A user space tool (kdump initramfs loader like kdump-utils) create
    key items inside /sys/kernel/config/crash_dm_crypt_keys to inform
    the 1st kernel which keys are needed.

 3. When the kdump initramfs is loaded by the kexec_file_load
    syscall, the 1st kernel will iterate created key items, save the
    keys to kdump reserved memory.

 4. When the 1st kernel crashes and the kdump initramfs is booted, the
    kdump initramfs asks the kdump kernel to create a user key using the
    key stored in kdump reserved memory by writing yes to
    /sys/kernel/crash_dm_crypt_keys/restore. Then the LUKS encrypted
    device is unlocked with libcryptsetup's --volume-key-keyring API.

 5. The system gets rebooted to the 1st kernel after dumping vmcore to
    the LUKS encrypted device is finished

After libcryptsetup saving the LUKS volume keys to specified keyring,
whoever takes this should be responsible for the safety of these copies of
keys.  The keys will be saved in the memory area exclusively reserved for
kdump where even the 1st kernel has no direct access.  And further more,
two additional protections are added,
 - save the copy randomly in kdump reserved memory as suggested by Jan
 - clear the _PAGE_PRESENT flag of the page that stores the copy as
   suggested by Pingfan

This patchset only supports x86.  There will be patches to support other
architectures once this patch set gets merged.


This patch (of 9):

Currently, kexec_buf is placed in order which means for the same machine,
the info in the kexec_buf is always located at the same position each time
the machine is booted.  This may cause a risk for sensitive information
like LUKS volume key.  Now struct kexec_buf has a new field random which
indicates it's supposed to be placed in a random position.

Note this feature is enabled only when CONFIG_CRASH_DUMP is enabled.  So
it only takes effect for kdump and won't impact kexec reboot.

Link: https://lkml.kernel.org/r/20250502011246.99238-1-coxu@redhat.com
Link: https://lkml.kernel.org/r/20250502011246.99238-2-coxu@redhat.com
Signed-off-by: Coiby Xu <coxu@redhat.com>
Suggested-by: Jan Pazdziora <jpazdziora@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |   30 ++++++++++++++++++++++++++++++
 kernel/kexec_file.c   |    3 +++
 2 files changed, 33 insertions(+)

--- a/include/linux/kexec.h~kexec_file-allow-to-place-kexec_buf-randomly
+++ a/include/linux/kexec.h
@@ -25,6 +25,10 @@
 
 extern note_buf_t __percpu *crash_notes;
 
+#ifdef CONFIG_CRASH_DUMP
+#include <linux/prandom.h>
+#endif
+
 #ifdef CONFIG_KEXEC_CORE
 #include <linux/list.h>
 #include <linux/compat.h>
@@ -169,6 +173,7 @@ int kexec_image_post_load_cleanup_defaul
  * @buf_min:	The buffer can't be placed below this address.
  * @buf_max:	The buffer can't be placed above this address.
  * @top_down:	Allocate from top of memory.
+ * @random:	Place the buffer at a random position.
  */
 struct kexec_buf {
 	struct kimage *image;
@@ -180,8 +185,33 @@ struct kexec_buf {
 	unsigned long buf_min;
 	unsigned long buf_max;
 	bool top_down;
+#ifdef CONFIG_CRASH_DUMP
+	bool random;
+#endif
 };
 
+
+#ifdef CONFIG_CRASH_DUMP
+static inline void kexec_random_range_start(unsigned long start,
+					    unsigned long end,
+					    struct kexec_buf *kbuf,
+					    unsigned long *temp_start)
+{
+	unsigned short i;
+
+	if (kbuf->random) {
+		get_random_bytes(&i, sizeof(unsigned short));
+		*temp_start = start + (end - start) / USHRT_MAX * i;
+	}
+}
+#else
+static inline void kexec_random_range_start(unsigned long start,
+					    unsigned long end,
+					    struct kexec_buf *kbuf,
+					    unsigned long *temp_start)
+{}
+#endif
+
 int kexec_load_purgatory(struct kimage *image, struct kexec_buf *kbuf);
 int kexec_purgatory_get_set_symbol(struct kimage *image, const char *name,
 				   void *buf, unsigned int size,
--- a/kernel/kexec_file.c~kexec_file-allow-to-place-kexec_buf-randomly
+++ a/kernel/kexec_file.c
@@ -449,6 +449,7 @@ static int locate_mem_hole_top_down(unsi
 
 	temp_end = min(end, kbuf->buf_max);
 	temp_start = temp_end - kbuf->memsz + 1;
+	kexec_random_range_start(temp_start, temp_end, kbuf, &temp_start);
 
 	do {
 		/* align down start */
@@ -493,6 +494,8 @@ static int locate_mem_hole_bottom_up(uns
 
 	temp_start = max(start, kbuf->buf_min);
 
+	kexec_random_range_start(temp_start, end, kbuf, &temp_start);
+
 	do {
 		temp_start = ALIGN(temp_start, kbuf->buf_align);
 		temp_end = temp_start + kbuf->memsz - 1;
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

