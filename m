From: akpm@linux-foundation.org
Subject: + documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch added to -mm tree
Date: Fri, 09 Apr 2010 16:15:44 -0700
Message-ID: <201004092315.o39NFiND017230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233Ab0DIXQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 19:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, fweisbec@gmail.com, hch@infradead.org, jkacur@redhat.com


The patch titled
     Documentation/filesystems/Locking: update documentation on llseek() wrt BKL
has been added to the -mm tree.  Its filename is
     documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

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
Subject: Documentation/filesystems/Locking: update documentation on llseek() wrt BKL
From: Jan Blunck <jblunck@suse.de>

The inode's i_size is not protected by the big kernel lock.  Therefore it
does not make sense to recommend taking the BKL in filesystems llseek
operations.  Instead it should use the inode's mutex or use just use
i_size_read() instead.  Add a note that this is not protecting
file->f_pos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/Locking~documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl
+++ a/Documentation/filesystems/Locking
@@ -429,8 +429,9 @@ check_flags:		no
 implementations.  If your fs is not using generic_file_llseek, you
 need to acquire and release the appropriate locks in your ->llseek().
 For many filesystems, it is probably safe to acquire the inode
-semaphore.  Note some filesystems (i.e. remote ones) provide no
-protection for i_size so you will need to use the BKL.
+mutex or just to use i_size_read() instead.
+Note: this does not protect the file->f_pos against concurrent modifications
+since this is something the userspace has to take care about.
 
 Note: ext2_release() was *the* source of contention on fs-intensive
 loads and dropping BKL on ->release() helps to get rid of that (we still
_

Patches currently in -mm which might be from jblunck@suse.de are

osst-update-ppos-instead-of-using-file-f_pos.patch
drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
zcrypt-use-nonseekable_open.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

