From: akpm@linux-foundation.org
Subject: + docbook-make-kernel-locking-table-readable.patch added to -mm tree
Date: Mon, 14 May 2007 22:45:07 -0700
Message-ID: <200705150545.l4F5j7TE002554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756224AbXEOFpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     docbook: make kernel-locking table readable
has been added to the -mm tree.  Its filename is
     docbook-make-kernel-locking-table-readable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: docbook: make kernel-locking table readable
From: Randy Dunlap <randy.dunlap@oracle.com>

Andi Kleen pointed out to me that the kernel locking cheat sheet
table entries are unreadable.

Make table entries smaller so that pdf and ps output is readable
(columns were being overwritten and garbled) by using abbreviations.
This allows the tables to fit on one page cleanly.
Add a Legend for the abbreviations:
  SLIS: spin_lock_irqsave
  SLI:  spin_lock_irq
  SL:   spin_lock
  SLBH: spin_lock_bh
  DI:   down_interruptible

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-locking.tmpl |  123 ++++++++++++--------
 1 file changed, 78 insertions(+), 45 deletions(-)

diff -puN Documentation/DocBook/kernel-locking.tmpl~docbook-make-kernel-locking-table-readable Documentation/DocBook/kernel-locking.tmpl
--- a/Documentation/DocBook/kernel-locking.tmpl~docbook-make-kernel-locking-table-readable
+++ a/Documentation/DocBook/kernel-locking.tmpl
@@ -551,10 +551,12 @@
 	<function>spin_lock_irqsave()</function>, which is a superset
 	of all other spinlock primitives.
    </para>
+
    <table>
 <title>Table of Locking Requirements</title>
 <tgroup cols="11">
 <tbody>
+
 <row>
 <entry></entry>
 <entry>IRQ Handler A</entry>
@@ -576,97 +578,128 @@
 
 <row>
 <entry>IRQ Handler B</entry>
-<entry>spin_lock_irqsave</entry>
+<entry>SLIS</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>Softirq A</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
 </row>
 
 <row>
 <entry>Softirq B</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 </row>
 
 <row>
 <entry>Tasklet A</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>Tasklet B</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>Timer A</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>Timer B</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
-<entry>spin_lock</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
+<entry>SL</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>User Context A</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
 <entry>None</entry>
 </row>
 
 <row>
 <entry>User Context B</entry>
+<entry>SLI</entry>
+<entry>SLI</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>SLBH</entry>
+<entry>DI</entry>
+<entry>None</entry>
+</row>
+
+</tbody>
+</tgroup>
+</table>
+
+   <table>
+<title>Legend for Locking Requirements Table</title>
+<tgroup cols="2">
+<tbody>
+
+<row>
+<entry>SLIS</entry>
+<entry>spin_lock_irqsave</entry>
+</row>
+<row>
+<entry>SLI</entry>
 <entry>spin_lock_irq</entry>
-<entry>spin_lock_irq</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
-<entry>spin_lock_bh</entry>
+</row>
+<row>
+<entry>SL</entry>
+<entry>spin_lock</entry>
+</row>
+<row>
+<entry>SLBH</entry>
 <entry>spin_lock_bh</entry>
+</row>
+<row>
+<entry>DI</entry>
 <entry>down_interruptible</entry>
-<entry>None</entry>
 </row>
 
 </tbody>
 </tgroup>
 </table>
+
 </sect1>
 </chapter>
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
parport-mailing-list-is-subscribers-only.patch
docbook-make-kernel-locking-table-readable.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-kstrndup.patch
add-argv_split.patch
add-argv_split-fix.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit.patch
profile-likely-unlikely-macros.patch
