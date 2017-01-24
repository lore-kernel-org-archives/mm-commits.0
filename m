From: akpm@linux-foundation.org
Subject: [patch 11/26] Documentation/filesystems/proc.txt: add VmPin
Date: Tue, 24 Jan 2017 15:18:13 -0800
Message-ID: <5887e0b5.YacPix2+d+D9UYso%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdAXXSO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, fabf@skynet.be, cl@linux.com

From: Fabian Frederick <fabf@skynet.be>
Subject: Documentation/filesystems/proc.txt: add VmPin

Commit bc3e53f682d9 ("mm: distinguish between mlocked and pinned pages")
added VmPin in /proc/<pid>/status.  Report that in
Documentation/filesystems/proc.txt

Also move Umask after Name to keep correct order.

Link: http://lkml.kernel.org/r/20170114201219.30387-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/proc.txt~documentation-filesystems-proctxt-add-vmpin Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~documentation-filesystems-proctxt-add-vmpin
+++ a/Documentation/filesystems/proc.txt
@@ -212,10 +212,11 @@ asynchronous manner and the value may no
 snapshot of a moment, you can see /proc/<pid>/smaps file and scan page table.
 It's slow but very precise.
 
-Table 1-2: Contents of the status files (as of 4.1)
+Table 1-2: Contents of the status files (as of 4.8)
 ..............................................................................
  Field                       Content
  Name                        filename of the executable
+ Umask                       file mode creation mask
  State                       state (R is running, S is sleeping, D is sleeping
                              in an uninterruptible wait, Z is zombie,
 			     T is traced or stopped)
@@ -226,7 +227,6 @@ Table 1-2: Contents of the status files
  TracerPid                   PID of process tracing this process (0 if not)
  Uid                         Real, effective, saved set, and  file system UIDs
  Gid                         Real, effective, saved set, and  file system GIDs
- Umask                       file mode creation mask
  FDSize                      number of file descriptor slots currently allocated
  Groups                      supplementary group list
  NStgid                      descendant namespace thread group ID hierarchy
@@ -236,6 +236,7 @@ Table 1-2: Contents of the status files
  VmPeak                      peak virtual memory size
  VmSize                      total program size
  VmLck                       locked memory size
+ VmPin                       pinned memory size
  VmHWM                       peak resident set size ("high water mark")
  VmRSS                       size of memory portions. It contains the three
                              following parts (VmRSS = RssAnon + RssFile + RssShmem)
_
