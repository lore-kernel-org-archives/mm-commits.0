From: akpm@linux-foundation.org
Subject: + documentation-filesystems-proctxt-add-vmpin.patch added to -mm
 tree
Date: Tue, 17 Jan 2017 15:36:23 -0800
Message-ID: <587eaa77.avd+0Ut6qyssTf12%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52384 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbdAQXhB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 18:37:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems/proc.txt: add VmPin
has been added to the -mm tree.  Its filename is
     documentation-filesystems-proctxt-add-vmpin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-filesystems-proctxt-add-vmpin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-filesystems-proctxt-add-vmpin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from fabf@skynet.be are

documentation-filesystems-proctxt-add-vmpin.patch
fs-add-i_blocksize.patch

