From: akpm@linux-foundation.org
Subject: [merged] documentation-update-mmiotracetxt.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:31:33 -0800
Message-ID: <200912292131.nBTLVX4B008499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbZL2Vbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:31:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, pq@iki.fi, mm-commits@vger.kernel.org


The patch titled
     Documentation: update mmiotrace.txt
has been removed from the -mm tree.  Its filename was
     documentation-update-mmiotracetxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: update mmiotrace.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos, spellos, hyphenation, line lengths.

BTW: are there some userspace tools?  There is a reference to some at the
wiki page, but there are no tools listed there.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/mmiotrace.txt |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN Documentation/trace/mmiotrace.txt~documentation-update-mmiotracetxt Documentation/trace/mmiotrace.txt
--- a/Documentation/trace/mmiotrace.txt~documentation-update-mmiotracetxt
+++ a/Documentation/trace/mmiotrace.txt
@@ -44,7 +44,8 @@ Check for lost events.
 Usage
 -----
 
-Make sure debugfs is mounted to /sys/kernel/debug. If not, (requires root privileges)
+Make sure debugfs is mounted to /sys/kernel/debug.
+If not (requires root privileges):
 $ mount -t debugfs debugfs /sys/kernel/debug
 
 Check that the driver you are about to trace is not loaded.
@@ -91,7 +92,7 @@ $ dmesg > dmesg.txt
 $ tar zcf pciid-nick-mmiotrace.tar.gz mydump.txt lspci.txt dmesg.txt
 and then send the .tar.gz file. The trace compresses considerably. Replace
 "pciid" and "nick" with the PCI ID or model name of your piece of hardware
-under investigation and your nick name.
+under investigation and your nickname.
 
 
 How Mmiotrace Works
@@ -100,7 +101,7 @@ How Mmiotrace Works
 Access to hardware IO-memory is gained by mapping addresses from PCI bus by
 calling one of the ioremap_*() functions. Mmiotrace is hooked into the
 __ioremap() function and gets called whenever a mapping is created. Mapping is
-an event that is recorded into the trace log. Note, that ISA range mappings
+an event that is recorded into the trace log. Note that ISA range mappings
 are not caught, since the mapping always exists and is returned directly.
 
 MMIO accesses are recorded via page faults. Just before __ioremap() returns,
@@ -122,11 +123,11 @@ Trace Log Format
 ----------------
 
 The raw log is text and easily filtered with e.g. grep and awk. One record is
-one line in the log. A record starts with a keyword, followed by keyword
-dependant arguments. Arguments are separated by a space, or continue until the
+one line in the log. A record starts with a keyword, followed by keyword-
+dependent arguments. Arguments are separated by a space, or continue until the
 end of line. The format for version 20070824 is as follows:
 
-Explanation	Keyword	Space separated arguments
+Explanation	Keyword	Space-separated arguments
 ---------------------------------------------------------------------------
 
 read event	R	width, timestamp, map id, physical, value, PC, PID
@@ -136,7 +137,7 @@ iounmap event	UNMAP	timestamp, map id, P
 marker		MARK	timestamp, text
 version		VERSION	the string "20070824"
 info for reader	LSPCI	one line from lspci -v
-PCI address map	PCIDEV	space separated /proc/bus/pci/devices data
+PCI address map	PCIDEV	space-separated /proc/bus/pci/devices data
 unk. opcode	UNKNOWN	timestamp, map id, physical, data, PC, PID
 
 Timestamp is in seconds with decimals. Physical is a PCI bus address, virtual
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docs-large-update-to-ioctl-numbertxt.patch
linux-next.patch
documentation-update-ring-buffer-designtxt.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

