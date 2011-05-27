From: akpm@linux-foundation.org
Subject: [merged] documentation-accounting-getdelaysc-handle-sendto-failures.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:28 -0700
Message-ID: <201105271955.p4RJtXio017465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932223Ab1E0Tz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, justinmattock@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/accounting/getdelays.c: handle sendto() failures
has been removed from the -mm tree.  Its filename was
     documentation-accounting-getdelaysc-handle-sendto-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/accounting/getdelays.c: handle sendto() failures
From: Andrew Morton <akpm@linux-foundation.org>

Documentation/accounting/getdelays.c: In function `get_family_id':
Documentation/accounting/getdelays.c:172:14: warning: variable `rc' set but not used [-Wunused-but-set-variable]

Reported-by: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-handle-sendto-failures Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-handle-sendto-failures
+++ a/Documentation/accounting/getdelays.c
@@ -177,6 +177,8 @@ static int get_family_id(int sd)
 	rc = send_cmd(sd, GENL_ID_CTRL, getpid(), CTRL_CMD_GETFAMILY,
 			CTRL_ATTR_FAMILY_NAME, (void *)name,
 			strlen(TASKSTATS_GENL_NAME)+1);
+	if (rc < 0)
+		return 0;	/* sendto() failure? */
 
 	rep_len = recv(sd, &ans, sizeof(ans), 0);
 	if (ans.n.nlmsg_type == NLMSG_ERROR ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

