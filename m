From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:18:46 -0700
Message-ID: <20130430221846.944C031C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:44626 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3D3WSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:18:47 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so113943yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:18:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, raphael.scarv@gmail.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix
has been removed from the -mm tree.  Its filename was
     kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch

This patch was dropped because it was folded into kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix

simplify code

Cc: Raphael S. Carvalho <raphael.scarv@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/pid.c~kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix kernel/pid.c
--- a/kernel/pid.c~kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix
+++ a/kernel/pid.c
@@ -183,15 +183,19 @@ static int alloc_pidmap(struct pid_names
 				break;
 		}
 		if (likely(atomic_read(&map->nr_free))) {
-			do {
+			for ( ; ; ) {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
 					set_last_pid(pid_ns, last, pid);
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
-			} while (offset < BITS_PER_PAGE &&
-				(pid = mk_pid(pid_ns, map, offset)) < pid_max);
+				if (offset >= BITS_PER_PAGE)
+					break;
+				pid = mk_pid(pid_ns, map, offset);
+				if (pid >= pid_max)
+					break;
+			}
 		}
 		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
 			++map;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
usermodehelper-export-_exec-and-_setup-functions.patch
kexec-use-min_t-to-simplify-logic.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap.patch
pid_namespacec-h-simplify-defines-fix.patch

