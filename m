From: akpm@linux-foundation.org
Subject: + drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch added to -mm tree
Date: Wed, 15 Jun 2011 15:34:45 -0700
Message-ID: <201106152312.p5FNC1vt025333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab1FOXMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 19:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@infradead.org, greg@kroah.com, w.d.hubbs@gmail.com


The patch titled
     drivers/staging/speakup/devsynth.c: fix "buffer size is not provably correct" error
has been added to the -mm tree.  Its filename is
     drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/speakup/devsynth.c: fix "buffer size is not provably correct" error
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allmodconfig:

In file included from /usr/src/devel/arch/x86/include/asm/uaccess.h:572,
                 from include/linux/uaccess.h:5,
                 from drivers/staging/speakup/devsynth.c:4:
In function 'copy_from_user',
    inlined from 'speakup_file_write' at drivers/staging/speakup/devsynth.c:28:
arch/x86/include/asm/uaccess_64.h:64: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct

I'm not sure what was unprovable about it, but size_t is the correct type
anyway.

Also replace needless min_t() with min()

Cc: William Hubbs <w.d.hubbs@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/speakup/devsynth.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/staging/speakup/devsynth.c~drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error drivers/staging/speakup/devsynth.c
--- a/drivers/staging/speakup/devsynth.c~drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error
+++ a/drivers/staging/speakup/devsynth.c
@@ -18,13 +18,14 @@ static ssize_t speakup_file_write(struct
 {
 	size_t count = nbytes;
 	const char *ptr = buffer;
-	int bytes;
+	size_t bytes;
 	unsigned long flags;
 	u_char buf[256];
+
 	if (synth == NULL)
 		return -ENODEV;
 	while (count > 0) {
-		bytes = min_t(size_t, count, sizeof(buf));
+		bytes = min(count, sizeof(buf));
 		if (copy_from_user(buf, ptr, bytes))
 			return -EFAULT;
 		count -= bytes;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
mm-fix-negative-commitlimit-when-gigantic-hugepages-are-allocated.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch

