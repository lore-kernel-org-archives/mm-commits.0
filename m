From: akpm@linux-foundation.org
Subject: + arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch added to -mm tree
Date: Fri, 09 Apr 2010 16:15:21 -0700
Message-ID: <201004092315.o39NFLRQ017181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236Ab0DIXPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 19:15:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, fweisbec@gmail.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     arch/cris/arch-v10/drivers/eeprom.c: eeprom_read()/eeprom_write() should update ppos instead of file->f_pos
has been added to the -mm tree.  Its filename is
     arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch

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
Subject: arch/cris/arch-v10/drivers/eeprom.c: eeprom_read()/eeprom_write() should update ppos instead of file->f_pos
From: jan Blunck <jblunck@suse.de>

eeprom_read()/eeprom_write() modify file->f_pos directly instead of the
ppos given.  The VFS later updates the file->f_pos and overwrites it with
the unchanged value of ppos.  Since nothing touches the struct file in
eeprom_read()/eeprom_write() now, the on stack allocated struct file in
eeprom_read_buf()/eeprom_write_buf() can be removed as well.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/eeprom.c |   34 +++++++++-----------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff -puN arch/cris/arch-v10/drivers/eeprom.c~arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos arch/cris/arch-v10/drivers/eeprom.c
--- a/arch/cris/arch-v10/drivers/eeprom.c~arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos
+++ a/arch/cris/arch-v10/drivers/eeprom.c
@@ -439,20 +439,18 @@ static loff_t eeprom_lseek(struct file *
 
 static int eeprom_read_buf(loff_t addr, char * buf, int count)
 {
-  struct file f;
-
-  f.f_pos = addr;
-  return eeprom_read(&f, buf, count, &addr);
+  return eeprom_read(NULL, buf, count, &addr);
 }
 
 
 
 /* Reads data from eeprom. */
 
-static ssize_t eeprom_read(struct file * file, char * buf, size_t count, loff_t *off)
+static ssize_t eeprom_read(struct file * file, char * buf, size_t count,
+			   loff_t *ppos)
 {
   int read=0;
-  unsigned long p = file->f_pos;
+  loff_t p = *ppos;
 
   unsigned char page;
 
@@ -498,11 +496,9 @@ static ssize_t eeprom_read(struct file *
 
   /* go on with the actual read */
   read = read_from_eeprom( buf, count);
-  
+
   if(read > 0)
-  {
-    file->f_pos += read;
-  }
+    *ppos += read;
 
   eeprom.busy--;
   wake_up_interruptible(&eeprom.wait_q);
@@ -513,18 +509,14 @@ static ssize_t eeprom_read(struct file *
 
 static int eeprom_write_buf(loff_t addr, const char * buf, int count)
 {
-  struct file f;
-
-  f.f_pos = addr;
-  
-  return eeprom_write(&f, buf, count, &addr);
+  return eeprom_write(NULL, buf, count, &addr);
 }
 
 
 /* Writes data to eeprom. */
 
 static ssize_t eeprom_write(struct file * file, const char * buf, size_t count,
-                            loff_t *off)
+			    loff_t *ppos)
 {
   int i, written, restart=1;
   unsigned long p;
@@ -543,9 +535,9 @@ static ssize_t eeprom_write(struct file 
   {
     restart = 0;
     written = 0;
-    p = file->f_pos;
-   
-    
+    p = *ppos;
+
+
     while( (written < count) && (p < eeprom.size))
     {
       /* address the eeprom */
@@ -671,10 +663,10 @@ static ssize_t eeprom_write(struct file 
 
   eeprom.busy--;
   wake_up_interruptible(&eeprom.wait_q);
-  if (written == 0 && file->f_pos >= eeprom.size){
+  if (written == 0 && *ppos >= eeprom.size){
     return -ENOSPC;
   }
-  file->f_pos += written;
+  *ppos += written;
   return written;
 }
 
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

