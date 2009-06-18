From: akpm@linux-foundation.org
Subject: [merged] proctxt-update-kernel-filesystem-proctxt-documentation.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:43:58 -0700
Message-ID: <200906182243.n5IMhwuV003008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757153AbZFRWoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     proc.txt: update kernel filesystem/proc.txt documentation
has been removed from the -mm tree.  Its filename was
     proctxt-update-kernel-filesystem-proctxt-documentation.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: proc.txt: update kernel filesystem/proc.txt documentation
=46rom: Stefani Seibold <stefani@seibold.net>

An update for the "Process-Specific Subdirectories" section to reflect =
the
changes till kernel 2.6.30.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |  242 +++++++++++++++++++++------
 1 file changed, 190 insertions(+), 52 deletions(-)

diff -puN Documentation/filesystems/proc.txt~proctxt-update-kernel-file=
system-proctxt-documentation Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proctxt-update-kernel-filesyst=
em-proctxt-documentation
+++ a/Documentation/filesystems/proc.txt
@@ -5,11 +5,12 @@
                   Bodo Bauer <bb@ricochet.net>
=20
 2.4.x update	  Jorge Nerin <comandante@zaralinux.com>      November 14=
 2000
-move /proc/sys	  Shen Feng <shen@cn.fujitsu.com>		    April 1 2009
+move /proc/sys	  Shen Feng <shen@cn.fujitsu.com>		  April 1 2009
 ----------------------------------------------------------------------=
--------
 Version 1.3                                              Kernel versio=
n 2.2.12
 					      Kernel version 2.4.0-test11-pre4
 ----------------------------------------------------------------------=
--------
+fixes/update part 1.1  Stefani Seibold <stefani@seibold.net>       Jun=
e 9 2009
=20
 Table of Contents
 -----------------
@@ -116,7 +117,7 @@ The link  self  points  to  the  process
 subdirectory has the entries listed in Table 1-1.
=20
=20
-Table 1-1: Process specific entries in /proc=20
+Table 1-1: Process specific entries in /proc
 ......................................................................=
=2E.......
  File		Content
  clear_refs	Clears page referenced bits shown in smaps output
@@ -134,46 +135,103 @@ Table 1-1: Process specific entries in /
  status		Process status in human readable form
  wchan		If CONFIG_KALLSYMS is set, a pre-decoded wchan
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
- smaps		Extension based on maps, the rss size for each mapped file
+ smaps		a extension based on maps, showing the memory consumption of
+		each mapping
 ......................................................................=
=2E.......
=20
 For example, to get the status information of a process, all you have =
to do is
 read the file /proc/PID/status:
=20
-  >cat /proc/self/status=20
-  Name:   cat=20
-  State:  R (running)=20
-  Pid:    5452=20
-  PPid:   743=20
+  >cat /proc/self/status
+  Name:   cat
+  State:  R (running)
+  Tgid:   5452
+  Pid:    5452
+  PPid:   743
   TracerPid:      0						(2.4)
-  Uid:    501     501     501     501=20
-  Gid:    100     100     100     100=20
-  Groups: 100 14 16=20
-  VmSize:     1112 kB=20
-  VmLck:         0 kB=20
-  VmRSS:       348 kB=20
-  VmData:       24 kB=20
-  VmStk:        12 kB=20
-  VmExe:         8 kB=20
-  VmLib:      1044 kB=20
-  SigPnd: 0000000000000000=20
-  SigBlk: 0000000000000000=20
-  SigIgn: 0000000000000000=20
-  SigCgt: 0000000000000000=20
-  CapInh: 00000000fffffeff=20
-  CapPrm: 0000000000000000=20
-  CapEff: 0000000000000000=20
-
+  Uid:    501     501     501     501
+  Gid:    100     100     100     100
+  FDSize: 256
+  Groups: 100 14 16
+  VmPeak:     5004 kB
+  VmSize:     5004 kB
+  VmLck:         0 kB
+  VmHWM:       476 kB
+  VmRSS:       476 kB
+  VmData:      156 kB
+  VmStk:        88 kB
+  VmExe:        68 kB
+  VmLib:      1412 kB
+  VmPTE:        20 kb
+  Threads:        1
+  SigQ:   0/28578
+  SigPnd: 0000000000000000
+  ShdPnd: 0000000000000000
+  SigBlk: 0000000000000000
+  SigIgn: 0000000000000000
+  SigCgt: 0000000000000000
+  CapInh: 00000000fffffeff
+  CapPrm: 0000000000000000
+  CapEff: 0000000000000000
+  CapBnd: ffffffffffffffff
+  voluntary_ctxt_switches:        0
+  nonvoluntary_ctxt_switches:     1
=20
 This shows you nearly the same information you would get if you viewed=
 it with
 the ps  command.  In  fact,  ps  uses  the  proc  file  system  to  ob=
tain its
-information. The  statm  file  contains  more  detailed  information a=
bout the
-process memory usage. Its seven fields are explained in Table 1-2.  Th=
e stat
-file contains details information about the process itself.  Its field=
s are
-explained in Table 1-3.
+information.  But you get a more detailed  view of the  process by rea=
ding the
+file /proc/PID/status. It fields are described in table 1-2.
=20
+The  statm  file  contains  more  detailed  information about the proc=
ess
+memory usage. Its seven fields are explained in Table 1-3.  The stat f=
ile
+contains details information about the process itself.  Its fields are
+explained in Table 1-4.
+
+Table 1-2: Contents of the statm files (as of 2.6.30-rc7)
+......................................................................=
=2E.......
+ Field                       Content
+ Name                        filename of the executable
+ State                       state (R is running, S is sleeping, D is =
sleeping
+                             in an uninterruptible wait, Z is zombie,
+			     T is traced or stopped)
+ Tgid                        thread group ID
+ Pid                         process id
+ PPid                        process id of the parent process
+ TracerPid                   PID of process tracing this process (0 if=
 not)
+ Uid                         Real, effective, saved set, and  file sys=
tem UIDs
+ Gid                         Real, effective, saved set, and  file sys=
tem GIDs
+ FDSize                      number of file descriptor slots currently=
 allocated
+ Groups                      supplementary group list
+ VmPeak                      peak virtual memory size
+ VmSize                      total program size
+ VmLck                       locked memory size
+ VmHWM                       peak resident set size ("high water mark"=
)
+ VmRSS                       size of memory portions
+ VmData                      size of data, stack, and text segments
+ VmStk                       size of data, stack, and text segments
+ VmExe                       size of text segment
+ VmLib                       size of shared library code
+ VmPTE                       size of page table entries
+ Threads                     number of threads
+ SigQ                        number of signals queued/max. number for =
queue
+ SigPnd                      bitmap of pending signals for the thread
+ ShdPnd                      bitmap of shared pending signals for the =
process
+ SigBlk                      bitmap of blocked signals
+ SigIgn                      bitmap of ignored signals
+ SigCgt                      bitmap of catched signals
+ CapInh                      bitmap of inheritable capabilities
+ CapPrm                      bitmap of permitted capabilities
+ CapEff                      bitmap of effective capabilities
+ CapBnd                      bitmap of capabilities bounding set
+ Cpus_allowed                mask of CPUs on which this process may ru=
n
+ Cpus_allowed_list           Same as previous, but in "list format"
+ Mems_allowed                mask of memory nodes allowed to this proc=
ess
+ Mems_allowed_list           Same as previous, but in "list format"
+ voluntary_ctxt_switches     number of voluntary context switches
+ nonvoluntary_ctxt_switches  number of non voluntary context switches
+......................................................................=
=2E.......
=20
-Table 1-2: Contents of the statm files (as of 2.6.8-rc3)
+Table 1-3: Contents of the statm files (as of 2.6.8-rc3)
 ......................................................................=
=2E.......
  Field    Content
  size     total program size (pages)		(same as VmSize in status)
@@ -188,7 +246,7 @@ Table 1-2: Contents of the statm files (
 ......................................................................=
=2E.......
=20
=20
-Table 1-3: Contents of the stat files (as of 2.6.22-rc3)
+Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
 ......................................................................=
=2E.......
  Field          Content
   pid           process id
@@ -222,10 +280,10 @@ Table 1-3: Contents of the stat files (a
   start_stack   address of the start of the stack
   esp           current value of ESP
   eip           current value of EIP
-  pending       bitmap of pending signals (obsolete)
-  blocked       bitmap of blocked signals (obsolete)
-  sigign        bitmap of ignored signals (obsolete)
-  sigcatch      bitmap of catched signals (obsolete)
+  pending       bitmap of pending signals
+  blocked       bitmap of blocked signals
+  sigign        bitmap of ignored signals
+  sigcatch      bitmap of catched signals
   wchan         address where process went to sleep
   0             (place holder)
   0             (place holder)
@@ -234,19 +292,99 @@ Table 1-3: Contents of the stat files (a
   rt_priority   realtime priority
   policy        scheduling policy (man sched_setscheduler)
   blkio_ticks   time spent waiting for block IO
+  gtime         guest time of the task in jiffies
+  cgtime        guest time of the task children in jiffies
 ......................................................................=
=2E.......
=20
+The /proc/PID/map file containing the currently mapped memory regions =
and
+their access permissions.
+
+The format is:
+
+address           perms offset  dev   inode      pathname
+
+08048000-08049000 r-xp 00000000 03:00 8312       /opt/test
+08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
+0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
+a7cb1000-a7cb2000 ---p 00000000 00:00 0
+a7cb2000-a7eb2000 rw-p 00000000 00:00 0
+a7eb2000-a7eb3000 ---p 00000000 00:00 0
+a7eb3000-a7ed5000 rw-p 00000000 00:00 0
+a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
+a8008000-a800a000 r--p 00133000 03:00 4222       /lib/libc.so.6
+a800a000-a800b000 rw-p 00135000 03:00 4222       /lib/libc.so.6
+a800b000-a800e000 rw-p 00000000 00:00 0
+a800e000-a8022000 r-xp 00000000 03:00 14462      /lib/libpthread.so.0
+a8022000-a8023000 r--p 00013000 03:00 14462      /lib/libpthread.so.0
+a8023000-a8024000 rw-p 00014000 03:00 14462      /lib/libpthread.so.0
+a8024000-a8027000 rw-p 00000000 00:00 0
+a8027000-a8043000 r-xp 00000000 03:00 8317       /lib/ld-linux.so.2
+a8043000-a8044000 r--p 0001b000 03:00 8317       /lib/ld-linux.so.2
+a8044000-a8045000 rw-p 0001c000 03:00 8317       /lib/ld-linux.so.2
+aff35000-aff4a000 rw-p 00000000 00:00 0          [stack]
+ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
+
+where "address" is the address space in the process that it occupies, =
"perms"
+is a set of permissions:
+
+ r =3D read
+ w =3D write
+ x =3D execute
+ s =3D shared
+ p =3D private (copy on write)
+
+"offset" is the offset into the mapping, "dev" is the device (major:mi=
nor), and
+"inode" is the inode  on that device.  0 indicates that  no inode is a=
ssociated
+with the memory region, as the case would be with BSS (uninitialized d=
ata).
+The "pathname" shows the name associated file for this mapping.  If th=
e mapping
+is not associated with a file:
+
+ [heap]                   =3D the heap of the program
+ [stack]                  =3D the stack of the main process
+ [vdso]                   =3D the "virtual dynamic shared object",
+                            the kernel system call handler
+
+ or if empty, the mapping is anonymous.
+
+
+The /proc/PID/smaps is an extension based on maps, showing the memory
+consumption for each of the process's mappings. For each of mappings t=
here
+is a series of lines such as the following:
+
+08048000-080bc000 r-xp 00000000 03:02 13130      /bin/bash
+Size:               1084 kB
+Rss:                 892 kB
+Pss:                 374 kB
+Shared_Clean:        892 kB
+Shared_Dirty:          0 kB
+Private_Clean:         0 kB
+Private_Dirty:         0 kB
+Referenced:          892 kB
+Swap:                  0 kB
+KernelPageSize:        4 kB
+MMUPageSize:           4 kB
+
+The first  of these lines shows  the same information  as is displayed=
 for the
+mapping in /proc/PID/maps.  The remaining lines show  the size of the =
mapping,
+the amount of the mapping that is currently resident in RAM, the "prop=
ortional
+set size=E2=80=9D (divide each shared page by the number of processes =
sharing it), the
+number of clean and dirty shared pages in the mapping, and the number =
of clean
+and dirty private pages in the mapping.  The "Referenced" indicates th=
e amount
+of memory currently marked as referenced or accessed.
+
+This file is only present if the CONFIG_MMU kernel configuration optio=
n is
+enabled.
=20
 1.2 Kernel data
 ---------------
=20
 Similar to  the  process entries, the kernel data files give informati=
on about
 the running kernel. The files used to obtain this information are cont=
ained in
-/proc and  are  listed  in Table 1-4. Not all of these will be present=
 in your
+/proc and  are  listed  in Table 1-5. Not all of these will be present=
 in your
 system. It  depends  on the kernel configuration and the loaded module=
s, which
 files are there, and which are missing.
=20
-Table 1-4: Kernel info in /proc
+Table 1-5: Kernel info in /proc
 ......................................................................=
=2E.......
  File        Content                                          =20
  apm         Advanced power management info                   =20
@@ -634,10 +772,10 @@ IDE devices:
=20
 More detailed  information  can  be  found  in  the  controller  speci=
fic
 subdirectories. These  are  named  ide0,  ide1  and  so  on.  Each  of=
  these
-directories contains the files shown in table 1-5.
+directories contains the files shown in table 1-6.
=20
=20
-Table 1-5: IDE controller info in  /proc/ide/ide?
+Table 1-6: IDE controller info in  /proc/ide/ide?
 ......................................................................=
=2E.......
  File    Content                                =20
  channel IDE channel (0 or 1)                   =20
@@ -647,11 +785,11 @@ Table 1-5: IDE controller info in  /proc
 ......................................................................=
=2E.......
=20
 Each device  connected  to  a  controller  has  a separate subdirector=
y in the
-controllers directory.  The  files  listed in table 1-6 are contained =
in these
+controllers directory.  The  files  listed in table 1-7 are contained =
in these
 directories.
=20
=20
-Table 1-6: IDE device information
+Table 1-7: IDE device information
 ......................................................................=
=2E.......
  File             Content                                   =20
  cache            The cache                                 =20
@@ -693,12 +831,12 @@ the drive parameters:
 1.4 Networking info in /proc/net
 --------------------------------
=20
-The subdirectory  /proc/net  follows  the  usual  pattern. Table 1-6 s=
hows the
+The subdirectory  /proc/net  follows  the  usual  pattern. Table 1-8 s=
hows the
 additional values  you  get  for  IP  version 6 if you configure the k=
ernel to
-support this. Table 1-7 lists the files and their meaning.
+support this. Table 1-9 lists the files and their meaning.
=20
=20
-Table 1-6: IPv6 info in /proc/net=20
+Table 1-8: IPv6 info in /proc/net
 ......................................................................=
=2E.......
  File       Content                                              =20
  udp6       UDP sockets (IPv6)                                   =20
@@ -713,7 +851,7 @@ Table 1-6: IPv6 info in /proc/net=20
 ......................................................................=
=2E.......
=20
=20
-Table 1-7: Network info in /proc/net=20
+Table 1-9: Network info in /proc/net
 ......................................................................=
=2E.......
  File          Content                                                =
        =20
  arp           Kernel  ARP table                                      =
        =20
@@ -837,10 +975,10 @@ The directory  /proc/parport  contains i
 your system.  It  has  one  subdirectory  for  each port, named after =
the port
 number (0,1,2,...).
=20
-These directories contain the four files shown in Table 1-8.
+These directories contain the four files shown in Table 1-10.
=20
=20
-Table 1-8: Files in /proc/parport=20
+Table 1-10: Files in /proc/parport
 ......................................................................=
=2E.......
  File      Content                                                    =
        =20
  autoprobe Any IEEE-1284 device ID information that has been acquired.=
        =20
@@ -858,10 +996,10 @@ Table 1-8: Files in /proc/parport=20
=20
 Information about  the  available  and actually used tty's can be foun=
d in the
 directory /proc/tty.You'll  find  entries  for drivers and line discip=
lines in
-this directory, as shown in Table 1-9.
+this directory, as shown in Table 1-11.
=20
=20
-Table 1-9: Files in /proc/tty=20
+Table 1-11: Files in /proc/tty
 ......................................................................=
=2E.......
  File          Content                                       =20
  drivers       list of drivers and their usage               =20
@@ -952,9 +1090,9 @@ Information about mounted ext4 file syst
 /proc/fs/ext4.  Each mounted filesystem will have a directory in
 /proc/fs/ext4 based on its device name (i.e., /proc/fs/ext4/hdc or
 /proc/fs/ext4/dm-0).   The files in each per-device directory are show=
n
-in Table 1-10, below.
+in Table 1-12, below.
=20
-Table 1-10: Files in /proc/fs/ext4/<devname>
+Table 1-12: Files in /proc/fs/ext4/<devname>
 ......................................................................=
=2E.......
  File            Content                                       =20
  mb_groups       details of multiblock allocator buddy cache of free b=
locks
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch
procfs-provide-stack-information-for-threads-v08.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
