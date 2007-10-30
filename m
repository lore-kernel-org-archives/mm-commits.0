From: akpm@linux-foundation.org
Subject: + mark-sys_open-sys_read-exports-unused.patch added to -mm tree
Date: Tue, 30 Oct 2007 12:55:49 -0700
Message-ID: <200710301955.l9UJtniH025229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41669 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990AbXJ3T41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 15:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com


The patch titled
     mark sys_open/sys_read exports unused
has been added to the -mm tree.  Its filename is
     mark-sys_open-sys_read-exports-unused.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark sys_open/sys_read exports unused
From: Arjan van de Ven <arjan@infradead.org>

sys_open / sys_read were used in the early 1.2 days to load firmware from
disk inside drivers.  Since 2.0 or so this was deprecated behavior, but
several drivers still were using this.  Since a few years we have a
request_firmware() API that implements this in a nice, consistent way. 
Only some old ISA sound drivers (pre-ALSA) still straggled along for some
time....  however with commit c2b1239a9f22f19c53543b460b24507d0e21ea0c the
last user is now gone.

This is a good thing, since using sys_open / sys_read etc for firmware is a
very buggy to dangerous thing to do; these operations put an fd in the
process file descriptor table....  which then can be tampered with from
other threads for example.  For those who don't want the firmware loader,
filp_open()/vfs_read are the better APIs to use, without this security
issue.

The patch below marks sys_open and sys_read unused now that they're
really not used anymore, and for deletion in the 2.6.25 timeframe.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c       |    2 +-
 fs/read_write.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/open.c~mark-sys_open-sys_read-exports-unused fs/open.c
--- a/fs/open.c~mark-sys_open-sys_read-exports-unused
+++ a/fs/open.c
@@ -1061,7 +1061,7 @@ asmlinkage long sys_open(const char __us
 	prevent_tail_call(ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_open);
+EXPORT_UNUSED_SYMBOL_GPL(sys_open); /* To be deleted for 2.6.25 */
 
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   int mode)
diff -puN fs/read_write.c~mark-sys_open-sys_read-exports-unused fs/read_write.c
--- a/fs/read_write.c~mark-sys_open-sys_read-exports-unused
+++ a/fs/read_write.c
@@ -370,7 +370,7 @@ asmlinkage ssize_t sys_read(unsigned int
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_read);
+EXPORT_UNUSED_SYMBOL_GPL(sys_read); /* to be deleted for 2.6.25 */
 
 asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
 {
_

Patches currently in -mm which might be from arjan@infradead.org are

acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-unionfs.patch
i386-and-x86_64-randomize-brk.patch
i386-and-x86_64-randomize-brk-fix.patch
mark-sys_open-sys_read-exports-unused.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
latencyc-use-qos-infrastructure.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
