From: akpm@linux-foundation.org
Subject: + documentation-for-io-accounting--reporting-via-procfs.patch added to -mm tree
Date: Sat, 03 Mar 2007 14:18:03 -0800
Message-ID: <200703032218.l23MI6Cb014036@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030489AbXCCWSI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 3 Mar 2007 17:18:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devzero@web.de


The patch titled
     Documentation for io-accounting / reporting via procfs
has been added to the -mm tree.  Its filename is
     documentation-for-io-accounting--reporting-via-procfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation for io-accounting / reporting via procfs
From: Roland Kletzing devzero@web.de

Add some documentation for the new and very useful io-accounting feature. 
It's being added to Documentation/filesystems/proc.txt

Signed-off-by: Roland Kletzing <devzero@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |  105 +++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff -puN Documentation/filesystems/proc.txt~documentation-for-io-accounting--reporting-via-procfs Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~documentation-for-io-accounting--reporting-via-procfs
+++ a/Documentation/filesystems/proc.txt
@@ -41,6 +41,7 @@ Table of Contents
   2.11	/proc/sys/fs/mqueue - POSIX message queues filesystem
   2.12	/proc/<pid>/oom_adj - Adjust the oom-killer score
   2.13	/proc/<pid>/oom_score - Display current oom-killer score
+  2.14	/proc/<pid>/io - Display the IO accounting fields
 
 ------------------------------------------------------------------------------
 Preface
@@ -1990,3 +1991,107 @@ need to  recompile  the kernel, or even 
 command to write value into these files, thereby changing the default settings
 of the kernel.
 ------------------------------------------------------------------------------
+
+2.14  /proc/<pid>/io - Display the IO accounting fields
+-------------------------------------------------------
+
+This file contains IO statistics for each running process
+
+Example
+-------
+
+test:/tmp # dd if=/dev/zero of=/tmp/test.dat &
+[1] 3828
+
+test:/tmp # cat /proc/3828/io
+rchar: 323934931
+wchar: 323929600
+syscr: 632687
+syscw: 632675
+read_bytes: 0
+write_bytes: 323932160
+cancelled_write_bytes: 0
+
+
+Description
+-----------
+
+rchar
+-----
+
+I/O counter: chars read
+The number of bytes which this task has caused to be read from storage. This
+is simply the sum of bytes which this process passed to read() and pread().
+It includes things like tty IO and it is unaffected by whether or not actual
+physical disk IO was required (the read might have been satisfied from
+pagecache)
+
+
+wchar
+-----
+
+I/O counter: chars written
+The number of bytes which this task has caused, or shall cause to be written
+to disk. Similar caveats apply here as with rchar.
+
+
+syscr
+-----
+
+I/O counter: read syscalls
+Attempt to count the number of read I/O operations, i.e. syscalls like read()
+and pread().
+
+
+syscw
+-----
+
+I/O counter: write syscalls
+Attempt to count the number of write I/O operations, i.e. syscalls like
+write() and pwrite().
+
+
+read_bytes
+----------
+
+I/O counter: bytes read
+Attempt to count the number of bytes which this process really did cause to
+be fetched from the storage layer. Done at the submit_bio() level, so it is
+accurate for block-backed filesystems. <please add status regarding NFS and
+CIFS at a later time>
+
+
+write_bytes
+-----------
+
+I/O counter: bytes written
+Attempt to count the number of bytes which this process caused to be sent to
+the storage layer. This is done at page-dirtying time.
+
+
+cancelled_write_bytes
+---------------------
+
+The big inaccuracy here is truncate. If a process writes 1MB to a file and
+then deletes the file, it will in fact perform no writeout. But it will have
+been accounted as having caused 1MB of write.
+In other words: The number of bytes which this process caused to not happen,
+by truncating pagecache. A task can cause "negative" IO too. If this task
+truncates some dirty pagecache, some IO which another task has been accounted
+for (in it's write_bytes) will not be happening. We _could_ just subtract that
+from the truncating task's write_bytes, but there is information loss in doing
+that.
+
+
+Note
+----
+
+At its current implementation state, this is a bit racy on 32-bit machines: if
+process A reads process B's /proc/pid/io while process B is updating one of
+those 64-bit counters, process A could see an intermediate result.
+
+
+More information about this can be found within the taskstats documentation in
+Documentation/accounting.
+
+------------------------------------------------------------------------------
_

Patches currently in -mm which might be from devzero@web.de are

documentation-for-io-accounting--reporting-via-procfs.patch
