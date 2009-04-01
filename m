From: akpm@linux-foundation.org
Subject: + update-documentation-filesystem-proctxt-and-documentation-sysctls.patch added to -mm tree
Date: Wed, 01 Apr 2009 12:52:16 -0700
Message-ID: <200904011952.n31JqGMB030050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbZDATzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shen@cn.fujitsu.com, davem@davemloft.net, randy.dunlap@oracle.com


The patch titled
     documentation: update Documentation/filesystem/proc.txt and Documentation/sysctls
has been added to the -mm tree.  Its filename is
     update-documentation-filesystem-proctxt-and-documentation-sysctls.patch

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
Subject: documentation: update Documentation/filesystem/proc.txt and Documentation/sysctls
From: Shen Feng <shen@cn.fujitsu.com>

Now /proc/sys is described in many places and much information is
redundant.  This patch updates the proc.txt and move the /proc/sys
desciption out to the files in Documentation/sysctls.

Details are:

merge
-  2.1  /proc/sys/fs - File system data
-  2.11 /proc/sys/fs/mqueue - POSIX message queues filesystem
-  2.17 /proc/sys/fs/epoll - Configuration options for the epoll interface
with Documentation/sysctls/fs.txt.

remove
-  2.2  /proc/sys/fs/binfmt_misc - Miscellaneous binary formats
since it's not better then the Documentation/binfmt_misc.txt.

merge
-  2.3  /proc/sys/kernel - general kernel parameters
with Documentation/sysctls/kernel.txt

remove
-  2.5  /proc/sys/dev - Device specific parameters
since it's obsolete the sysfs is used now.

remove
-  2.6  /proc/sys/sunrpc - Remote procedure calls
since it's not better then the Documentation/sysctls/sunrpc.txt

move
-  2.7  /proc/sys/net - Networking stuff
-  2.9  Appletalk
-  2.10 IPX
to newly created Documentation/sysctls/net.txt.

remove
-  2.8  /proc/sys/net/ipv4 - IPV4 settings
since it's not better then the Documentation/networking/ip-sysctl.txt.

add
- Chapter 3 Per-Process Parameters
to descibe /proc/<pid>/xxx parameters.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt | 1097 ---------------------------
 Documentation/sysctl/00-INDEX      |    2 
 Documentation/sysctl/fs.txt        |   74 +
 Documentation/sysctl/kernel.txt    |   53 +
 Documentation/sysctl/net.txt       |  174 ++++
 5 files changed, 329 insertions(+), 1071 deletions(-)

diff -puN Documentation/filesystems/proc.txt~update-documentation-filesystem-proctxt-and-documentation-sysctls Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~update-documentation-filesystem-proctxt-and-documentation-sysctls
+++ a/Documentation/filesystems/proc.txt
@@ -5,6 +5,7 @@
                   Bodo Bauer <bb@ricochet.net>
 
 2.4.x update	  Jorge Nerin <comandante@zaralinux.com>      November 14 2000
+move /proc/sys	  Shen Feng <shen@cn.fujitsu.com>		    April 1 2009
 ------------------------------------------------------------------------------
 Version 1.3                                              Kernel version 2.2.12
 					      Kernel version 2.4.0-test11-pre4
@@ -26,25 +27,17 @@ Table of Contents
   1.6	Parallel port info in /proc/parport
   1.7	TTY info in /proc/tty
   1.8	Miscellaneous kernel statistics in /proc/stat
+  1.9 Ext4 file system parameters
 
   2	Modifying System Parameters
-  2.1	/proc/sys/fs - File system data
-  2.2	/proc/sys/fs/binfmt_misc - Miscellaneous binary formats
-  2.3	/proc/sys/kernel - general kernel parameters
-  2.4	/proc/sys/vm - The virtual memory subsystem
-  2.5	/proc/sys/dev - Device specific parameters
-  2.6	/proc/sys/sunrpc - Remote procedure calls
-  2.7	/proc/sys/net - Networking stuff
-  2.8	/proc/sys/net/ipv4 - IPV4 settings
-  2.9	Appletalk
-  2.10	IPX
-  2.11	/proc/sys/fs/mqueue - POSIX message queues filesystem
-  2.12	/proc/<pid>/oom_adj - Adjust the oom-killer score
-  2.13	/proc/<pid>/oom_score - Display current oom-killer score
-  2.14	/proc/<pid>/io - Display the IO accounting fields
-  2.15	/proc/<pid>/coredump_filter - Core dump filtering settings
-  2.16	/proc/<pid>/mountinfo - Information about mounts
-  2.17	/proc/sys/fs/epoll - Configuration options for the epoll interface
+
+  3	Per-Process Parameters
+  3.1	/proc/<pid>/oom_adj - Adjust the oom-killer score
+  3.2	/proc/<pid>/oom_score - Display current oom-killer score
+  3.3	/proc/<pid>/io - Display the IO accounting fields
+  3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
+  3.5	/proc/<pid>/mountinfo - Information about mounts
+
 
 ------------------------------------------------------------------------------
 Preface
@@ -1015,1021 +1008,24 @@ review the kernel documentation in the d
 This chapter  is  heavily  based  on the documentation included in the pre 2.2
 kernels, and became part of it in version 2.2.1 of the Linux kernel.
 
-2.1 /proc/sys/fs - File system data
------------------------------------
-
-This subdirectory  contains  specific  file system, file handle, inode, dentry
-and quota information.
-
-Currently, these files are in /proc/sys/fs:
-
-dentry-state
-------------
-
-Status of  the  directory  cache.  Since  directory  entries  are  dynamically
-allocated and  deallocated,  this  file indicates the current status. It holds
-six values, in which the last two are not used and are always zero. The others
-are listed in table 2-1.
-
-
-Table 2-1: Status files of the directory cache 
-..............................................................................
- File       Content                                                            
- nr_dentry  Almost always zero                                                 
- nr_unused  Number of unused cache entries                                     
- age_limit  
-            in seconds after the entry may be reclaimed, when memory is short 
- want_pages internally                                                         
-..............................................................................
-
-dquot-nr and dquot-max
-----------------------
-
-The file dquot-max shows the maximum number of cached disk quota entries.
-
-The file  dquot-nr  shows  the  number of allocated disk quota entries and the
-number of free disk quota entries.
-
-If the number of available cached disk quotas is very low and you have a large
-number of simultaneous system users, you might want to raise the limit.
-
-file-nr and file-max
---------------------
-
-The kernel  allocates file handles dynamically, but doesn't free them again at
-this time.
-
-The value  in  file-max  denotes  the  maximum number of file handles that the
-Linux kernel will allocate. When you get a lot of error messages about running
-out of  file handles, you might want to raise this limit. The default value is
-10% of  RAM in kilobytes.  To  change it, just  write the new number  into the
-file:
-
-  # cat /proc/sys/fs/file-max 
-  4096 
-  # echo 8192 > /proc/sys/fs/file-max 
-  # cat /proc/sys/fs/file-max 
-  8192 
-
-
-This method  of  revision  is  useful  for  all customizable parameters of the
-kernel - simply echo the new value to the corresponding file.
-
-Historically, the three values in file-nr denoted the number of allocated file
-handles,  the number of  allocated but  unused file  handles, and  the maximum
-number of file handles. Linux 2.6 always  reports 0 as the number of free file
-handles -- this  is not an error,  it just means that the  number of allocated
-file handles exactly matches the number of used file handles.
-
-Attempts to  allocate more  file descriptors than  file-max are  reported with
-printk, look for "VFS: file-max limit <number> reached".
-
-inode-state and inode-nr
-------------------------
-
-The file inode-nr contains the first two items from inode-state, so we'll skip
-to that file...
-
-inode-state contains  two  actual numbers and five dummy values. The numbers
-are nr_inodes and nr_free_inodes (in order of appearance).
-
-nr_inodes
-~~~~~~~~~
-
-Denotes the  number  of  inodes the system has allocated. This number will
-grow and shrink dynamically.
-
-nr_open
--------
-
-Denotes the maximum number of file-handles a process can
-allocate. Default value is 1024*1024 (1048576) which should be
-enough for most machines. Actual limit depends on RLIMIT_NOFILE
-resource limit.
-
-nr_free_inodes
---------------
-
-Represents the  number of free inodes. Ie. The number of inuse inodes is
-(nr_inodes - nr_free_inodes).
-
-aio-nr and aio-max-nr
----------------------
-
-aio-nr is the running total of the number of events specified on the
-io_setup system call for all currently active aio contexts.  If aio-nr
-reaches aio-max-nr then io_setup will fail with EAGAIN.  Note that
-raising aio-max-nr does not result in the pre-allocation or re-sizing
-of any kernel data structures.
-
-2.2 /proc/sys/fs/binfmt_misc - Miscellaneous binary formats
------------------------------------------------------------
-
-Besides these  files, there is the subdirectory /proc/sys/fs/binfmt_misc. This
-handles the kernel support for miscellaneous binary formats.
-
-Binfmt_misc provides  the ability to register additional binary formats to the
-Kernel without  compiling  an additional module/kernel. Therefore, binfmt_misc
-needs to  know magic numbers at the beginning or the filename extension of the
-binary.
-
-It works by maintaining a linked list of structs that contain a description of
-a binary  format,  including  a  magic  with size (or the filename extension),
-offset and  mask,  and  the  interpreter name. On request it invokes the given
-interpreter with  the  original  program  as  argument,  as  binfmt_java  and
-binfmt_em86 and  binfmt_mz  do.  Since binfmt_misc does not define any default
-binary-formats, you have to register an additional binary-format.
-
-There are two general files in binfmt_misc and one file per registered format.
-The two general files are register and status.
-
-Registering a new binary format
--------------------------------
-
-To register a new binary format you have to issue the command
-
-  echo :name:type:offset:magic:mask:interpreter: > /proc/sys/fs/binfmt_misc/register 
-
-
-
-with appropriate  name (the name for the /proc-dir entry), offset (defaults to
-0, if  omitted),  magic, mask (which can be omitted, defaults to all 0xff) and
-last but  not  least,  the  interpreter that is to be invoked (for example and
-testing /bin/echo).  Type  can be M for usual magic matching or E for filename
-extension matching (give extension in place of magic).
-
-Check or reset the status of the binary format handler
-------------------------------------------------------
-
-If you  do a cat on the file /proc/sys/fs/binfmt_misc/status, you will get the
-current status (enabled/disabled) of binfmt_misc. Change the status by echoing
-0 (disables)  or  1  (enables)  or  -1  (caution:  this  clears all previously
-registered binary  formats)  to status. For example echo 0 > status to disable
-binfmt_misc (temporarily).
-
-Status of a single handler
---------------------------
-
-Each registered  handler has an entry in /proc/sys/fs/binfmt_misc. These files
-perform the  same function as status, but their scope is limited to the actual
-binary format.  By  cating this file, you also receive all related information
-about the interpreter/magic of the binfmt.
-
-Example usage of binfmt_misc (emulate binfmt_java)
---------------------------------------------------
-
-  cd /proc/sys/fs/binfmt_misc  
-  echo ':Java:M::\xca\xfe\xba\xbe::/usr/local/java/bin/javawrapper:' > register  
-  echo ':HTML:E::html::/usr/local/java/bin/appletviewer:' > register  
-  echo ':Applet:M::<!--applet::/usr/local/java/bin/appletviewer:' > register 
-  echo ':DEXE:M::\x0eDEX::/usr/bin/dosexec:' > register 
-
-
-These four  lines  add  support  for  Java  executables and Java applets (like
-binfmt_java, additionally  recognizing the .html extension with no need to put
-<!--applet> to  every  applet  file).  You  have  to  install  the JDK and the
-shell-script /usr/local/java/bin/javawrapper  too.  It  works  around  the
-brokenness of  the Java filename handling. To add a Java binary, just create a
-link to the class-file somewhere in the path.
-
-2.3 /proc/sys/kernel - general kernel parameters
-------------------------------------------------
-
-This directory  reflects  general  kernel  behaviors. As I've said before, the
-contents depend  on  your  configuration.  Here you'll find the most important
-files, along with descriptions of what they mean and how to use them.
-
-acct
-----
-
-The file contains three values; highwater, lowwater, and frequency.
-
-It exists  only  when  BSD-style  process  accounting is enabled. These values
-control its behavior. If the free space on the file system where the log lives
-goes below  lowwater  percentage,  accounting  suspends.  If  it  goes  above
-highwater percentage,  accounting  resumes. Frequency determines how often you
-check the amount of free space (value is in seconds). Default settings are: 4,
-2, and  30.  That is, suspend accounting if there is less than 2 percent free;
-resume it  if we have a value of 3 or more percent; consider information about
-the amount of free space valid for 30 seconds
-
-ctrl-alt-del
-------------
-
-When the value in this file is 0, ctrl-alt-del is trapped and sent to the init
-program to  handle a graceful restart. However, when the value is greater that
-zero, Linux's  reaction  to  this key combination will be an immediate reboot,
-without syncing its dirty buffers.
-
-[NOTE]
-    When a  program  (like  dosemu)  has  the  keyboard  in  raw  mode,  the
-    ctrl-alt-del is  intercepted  by  the  program  before it ever reaches the
-    kernel tty  layer,  and  it is up to the program to decide what to do with
-    it.
-
-domainname and hostname
------------------------
-
-These files  can  be controlled to set the NIS domainname and hostname of your
-box. For the classic darkstar.frop.org a simple:
-
-  # echo "darkstar" > /proc/sys/kernel/hostname 
-  # echo "frop.org" > /proc/sys/kernel/domainname 
-
-
-would suffice to set your hostname and NIS domainname.
-
-osrelease, ostype and version
------------------------------
-
-The names make it pretty obvious what these fields contain:
-
-  > cat /proc/sys/kernel/osrelease 
-  2.2.12 
-   
-  > cat /proc/sys/kernel/ostype 
-  Linux 
-   
-  > cat /proc/sys/kernel/version 
-  #4 Fri Oct 1 12:41:14 PDT 1999 
-
-
-The files  osrelease and ostype should be clear enough. Version needs a little
-more clarification.  The  #4 means that this is the 4th kernel built from this
-source base and the date after it indicates the time the kernel was built. The
-only way to tune these values is to rebuild the kernel.
-
-panic
------
-
-The value  in  this  file  represents  the  number of seconds the kernel waits
-before rebooting  on  a  panic.  When  you  use  the  software  watchdog,  the
-recommended setting  is  60. If set to 0, the auto reboot after a kernel panic
-is disabled, which is the default setting.
-
-printk
-------
-
-The four values in printk denote
-* console_loglevel,
-* default_message_loglevel,
-* minimum_console_loglevel and
-* default_console_loglevel
-respectively.
-
-These values  influence  printk()  behavior  when  printing  or  logging error
-messages, which  come  from  inside  the  kernel.  See  syslog(2)  for  more
-information on the different log levels.
-
-console_loglevel
-----------------
-
-Messages with a higher priority than this will be printed to the console.
-
-default_message_level
----------------------
-
-Messages without an explicit priority will be printed with this priority.
-
-minimum_console_loglevel
-------------------------
-
-Minimum (highest) value to which the console_loglevel can be set.
-
-default_console_loglevel
-------------------------
-
-Default value for console_loglevel.
-
-sg-big-buff
------------
-
-This file  shows  the size of the generic SCSI (sg) buffer. At this point, you
-can't tune  it  yet,  but  you  can  change  it  at  compile  time  by editing
-include/scsi/sg.h and changing the value of SG_BIG_BUFF.
-
-If you use a scanner with SANE (Scanner Access Now Easy) you might want to set
-this to a higher value. Refer to the SANE documentation on this issue.
-
-modprobe
---------
-
-The location  where  the  modprobe  binary  is  located.  The kernel uses this
-program to load modules on demand.
-
-unknown_nmi_panic
------------------
-
-The value in this file affects behavior of handling NMI. When the value is
-non-zero, unknown NMI is trapped and then panic occurs. At that time, kernel
-debugging information is displayed on console.
-
-NMI switch that most IA32 servers have fires unknown NMI up, for example.
-If a system hangs up, try pressing the NMI switch.
-
-panic_on_unrecovered_nmi
-------------------------
-
-The default Linux behaviour on an NMI of either memory or unknown is to continue
-operation. For many environments such as scientific computing it is preferable
-that the box is taken out and the error dealt with than an uncorrected
-parity/ECC error get propogated.
-
-A small number of systems do generate NMI's for bizarre random reasons such as
-power management so the default is off. That sysctl works like the existing
-panic controls already in that directory.
-
-nmi_watchdog
-------------
-
-Enables/Disables the NMI watchdog on x86 systems.  When the value is non-zero
-the NMI watchdog is enabled and will continuously test all online cpus to
-determine whether or not they are still functioning properly. Currently,
-passing "nmi_watchdog=" parameter at boot time is required for this function
-to work.
-
-If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel parameter), the
-NMI watchdog shares registers with oprofile. By disabling the NMI watchdog,
-oprofile may have more registers to utilize.
-
-msgmni
-------
-
-Maximum number of message queue ids on the system.
-This value scales to the amount of lowmem. It is automatically recomputed
-upon memory add/remove or ipc namespace creation/removal.
-When a value is written into this file, msgmni's value becomes fixed, i.e. it
-is not recomputed anymore when one of the above events occurs.
-Use auto_msgmni to change this behavior.
-
-auto_msgmni
------------
-
-Enables/Disables automatic recomputing of msgmni upon memory add/remove or
-upon ipc namespace creation/removal (see the msgmni description above).
-Echoing "1" into this file enables msgmni automatic recomputing.
-Echoing "0" turns it off.
-auto_msgmni default value is 1.
-
-
-2.4 /proc/sys/vm - The virtual memory subsystem
------------------------------------------------
-
-Please see: Documentation/sysctls/vm.txt for a description of these
+Please see: Documentation/sysctls/ directory for descriptions of these
 entries.
 
+------------------------------------------------------------------------------
+Summary
+------------------------------------------------------------------------------
+Certain aspects  of  kernel  behavior  can be modified at runtime, without the
+need to  recompile  the kernel, or even to reboot the system. The files in the
+/proc/sys tree  can  not only be read, but also modified. You can use the echo
+command to write value into these files, thereby changing the default settings
+of the kernel.
+------------------------------------------------------------------------------
 
-2.5 /proc/sys/dev - Device specific parameters
-----------------------------------------------
-
-Currently there is only support for CDROM drives, and for those, there is only
-one read-only  file containing information about the CD-ROM drives attached to
-the system:
-
-  >cat /proc/sys/dev/cdrom/info 
-  CD-ROM information, Id: cdrom.c 2.55 1999/04/25 
-   
-  drive name:             sr0     hdb 
-  drive speed:            32      40 
-  drive # of slots:       1       0 
-  Can close tray:         1       1 
-  Can open tray:          1       1 
-  Can lock tray:          1       1 
-  Can change speed:       1       1 
-  Can select disk:        0       1 
-  Can read multisession:  1       1 
-  Can read MCN:           1       1 
-  Reports media changed:  1       1 
-  Can play audio:         1       1 
-
-
-You see two drives, sr0 and hdb, along with a list of their features.
-
-2.6 /proc/sys/sunrpc - Remote procedure calls
----------------------------------------------
-
-This directory  contains four files, which enable or disable debugging for the
-RPC functions NFS, NFS-daemon, RPC and NLM. The default values are 0. They can
-be set to one to turn debugging on. (The default value is 0 for each)
-
-2.7 /proc/sys/net - Networking stuff
-------------------------------------
-
-The interface  to  the  networking  parts  of  the  kernel  is  located  in
-/proc/sys/net. Table  2-3  shows all possible subdirectories. You may see only
-some of them, depending on your kernel's configuration.
-
-
-Table 2-3: Subdirectories in /proc/sys/net 
-..............................................................................
- Directory Content             Directory  Content            
- core      General parameter   appletalk  Appletalk protocol 
- unix      Unix domain sockets netrom     NET/ROM            
- 802       E802 protocol       ax25       AX25               
- ethernet  Ethernet protocol   rose       X.25 PLP layer     
- ipv4      IP version 4        x25        X.25 protocol      
- ipx       IPX                 token-ring IBM token ring     
- bridge    Bridging            decnet     DEC net            
- ipv6      IP version 6                   
-..............................................................................
-
-We will  concentrate  on IP networking here. Since AX15, X.25, and DEC Net are
-only minor players in the Linux world, we'll skip them in this chapter. You'll
-find some  short  info on Appletalk and IPX further on in this chapter. Review
-the online  documentation  and the kernel source to get a detailed view of the
-parameters for  those  protocols.  In  this  section  we'll  discuss  the
-subdirectories printed  in  bold letters in the table above. As default values
-are suitable for most needs, there is no need to change these values.
-
-/proc/sys/net/core - Network core options
------------------------------------------
-
-rmem_default
-------------
-
-The default setting of the socket receive buffer in bytes.
-
-rmem_max
---------
-
-The maximum receive socket buffer size in bytes.
-
-wmem_default
-------------
-
-The default setting (in bytes) of the socket send buffer.
-
-wmem_max
---------
-
-The maximum send socket buffer size in bytes.
-
-message_burst and message_cost
-------------------------------
-
-These parameters  are used to limit the warning messages written to the kernel
-log from  the  networking  code.  They  enforce  a  rate  limit  to  make  a
-denial-of-service attack  impossible. A higher message_cost factor, results in
-fewer messages that will be written. Message_burst controls when messages will
-be dropped.  The  default  settings  limit  warning messages to one every five
-seconds.
-
-warnings
---------
-
-This controls console messages from the networking stack that can occur because
-of problems on the network like duplicate address or bad checksums. Normally,
-this should be enabled, but if the problem persists the messages can be
-disabled.
-
-netdev_budget
--------------
-
-Maximum number of packets taken from all interfaces in one polling cycle (NAPI
-poll). In one polling cycle interfaces which are registered to polling are
-probed in a round-robin manner. The limit of packets in one such probe can be
-set per-device via sysfs class/net/<device>/weight .
-
-netdev_max_backlog
-------------------
-
-Maximum number  of  packets,  queued  on  the  INPUT  side, when the interface
-receives packets faster than kernel can process them.
-
-optmem_max
-----------
-
-Maximum ancillary buffer size allowed per socket. Ancillary data is a sequence
-of struct cmsghdr structures with appended data.
-
-/proc/sys/net/unix - Parameters for Unix domain sockets
--------------------------------------------------------
-
-There are  only  two  files  in this subdirectory. They control the delays for
-deleting and destroying socket descriptors.
-
-2.8 /proc/sys/net/ipv4 - IPV4 settings
---------------------------------------
-
-IP version  4  is  still the most used protocol in Unix networking. It will be
-replaced by  IP version 6 in the next couple of years, but for the moment it's
-the de  facto  standard  for  the  internet  and  is  used  in most networking
-environments around  the  world.  Because  of the importance of this protocol,
-we'll have a deeper look into the subtree controlling the behavior of the IPv4
-subsystem of the Linux kernel.
-
-Let's start with the entries in /proc/sys/net/ipv4.
-
-ICMP settings
--------------
-
-icmp_echo_ignore_all and icmp_echo_ignore_broadcasts
-----------------------------------------------------
-
-Turn on (1) or off (0), if the kernel should ignore all ICMP ECHO requests, or
-just those to broadcast and multicast addresses.
-
-Please note that if you accept ICMP echo requests with a broadcast/multi\-cast
-destination address  your  network  may  be  used as an exploder for denial of
-service packet flooding attacks to other hosts.
-
-icmp_destunreach_rate, icmp_echoreply_rate, icmp_paramprob_rate and icmp_timeexeed_rate
----------------------------------------------------------------------------------------
-
-Sets limits  for  sending  ICMP  packets  to specific targets. A value of zero
-disables all  limiting.  Any  positive  value sets the maximum package rate in
-hundredth of a second (on Intel systems).
-
-IP settings
------------
-
-ip_autoconfig
--------------
-
-This file contains the number one if the host received its IP configuration by
-RARP, BOOTP, DHCP or a similar mechanism. Otherwise it is zero.
-
-ip_default_ttl
---------------
-
-TTL (Time  To  Live) for IPv4 interfaces. This is simply the maximum number of
-hops a packet may travel.
-
-ip_dynaddr
-----------
-
-Enable dynamic  socket  address rewriting on interface address change. This is
-useful for dialup interface with changing IP addresses.
-
-ip_forward
-----------
-
-Enable or  disable forwarding of IP packages between interfaces. Changing this
-value resets  all other parameters to their default values. They differ if the
-kernel is configured as host or router.
-
-ip_local_port_range
--------------------
-
-Range of  ports  used  by  TCP  and UDP to choose the local port. Contains two
-numbers, the  first  number  is the lowest port, the second number the highest
-local port.  Default  is  1024-4999.  Should  be  changed  to  32768-61000 for
-high-usage systems.
-
-ip_no_pmtu_disc
----------------
-
-Global switch  to  turn  path  MTU  discovery off. It can also be set on a per
-socket basis by the applications or on a per route basis.
-
-ip_masq_debug
--------------
-
-Enable/disable debugging of IP masquerading.
-
-IP fragmentation settings
--------------------------
-
-ipfrag_high_trash and ipfrag_low_trash
---------------------------------------
-
-Maximum memory  used to reassemble IP fragments. When ipfrag_high_thresh bytes
-of memory  is  allocated  for  this  purpose,  the  fragment handler will toss
-packets until ipfrag_low_thresh is reached.
-
-ipfrag_time
------------
-
-Time in seconds to keep an IP fragment in memory.
-
-TCP settings
-------------
-
-tcp_ecn
--------
-
-This file controls the use of the ECN bit in the IPv4 headers. This is a new
-feature about Explicit Congestion Notification, but some routers and firewalls
-block traffic that has this bit set, so it could be necessary to echo 0 to
-/proc/sys/net/ipv4/tcp_ecn if you want to talk to these sites. For more info
-you could read RFC2481.
-
-tcp_retrans_collapse
---------------------
-
-Bug-to-bug compatibility with some broken printers. On retransmit, try to send
-larger packets to work around bugs in certain TCP stacks. Can be turned off by
-setting it to zero.
-
-tcp_keepalive_probes
---------------------
-
-Number of  keep  alive  probes  TCP  sends  out,  until  it  decides  that the
-connection is broken.
-
-tcp_keepalive_time
-------------------
-
-How often  TCP  sends out keep alive messages, when keep alive is enabled. The
-default is 2 hours.
-
-tcp_syn_retries
----------------
-
-Number of  times  initial  SYNs  for  a  TCP  connection  attempt  will  be
-retransmitted. Should  not  be  higher  than 255. This is only the timeout for
-outgoing connections,  for  incoming  connections the number of retransmits is
-defined by tcp_retries1.
-
-tcp_sack
---------
-
-Enable select acknowledgments after RFC2018.
-
-tcp_timestamps
---------------
-
-Enable timestamps as defined in RFC1323.
-
-tcp_stdurg
-----------
-
-Enable the  strict  RFC793 interpretation of the TCP urgent pointer field. The
-default is  to  use  the  BSD  compatible interpretation of the urgent pointer
-pointing to the first byte after the urgent data. The RFC793 interpretation is
-to have  it  point  to  the last byte of urgent data. Enabling this option may
-lead to interoperability problems. Disabled by default.
-
-tcp_syncookies
---------------
-
-Only valid  when  the  kernel  was  compiled  with CONFIG_SYNCOOKIES. Send out
-syncookies when  the  syn backlog queue of a socket overflows. This is to ward
-off the common 'syn flood attack'. Disabled by default.
-
-Note that  the  concept  of a socket backlog is abandoned. This means the peer
-may not  receive  reliable  error  messages  from  an  over loaded server with
-syncookies enabled.
-
-tcp_window_scaling
-------------------
-
-Enable window scaling as defined in RFC1323.
-
-tcp_fin_timeout
----------------
-
-The length  of  time  in  seconds  it  takes to receive a final FIN before the
-socket is  always  closed.  This  is  strictly  a  violation  of  the  TCP
-specification, but required to prevent denial-of-service attacks.
-
-tcp_max_ka_probes
------------------
-
-Indicates how  many  keep alive probes are sent per slow timer run. Should not
-be set too high to prevent bursts.
-
-tcp_max_syn_backlog
--------------------
-
-Length of  the per socket backlog queue. Since Linux 2.2 the backlog specified
-in listen(2)  only  specifies  the  length  of  the  backlog  queue of already
-established sockets. When more connection requests arrive Linux starts to drop
-packets. When  syncookies  are  enabled the packets are still answered and the
-maximum queue is effectively ignored.
-
-tcp_retries1
-------------
-
-Defines how  often  an  answer  to  a  TCP connection request is retransmitted
-before giving up.
-
-tcp_retries2
-------------
-
-Defines how often a TCP packet is retransmitted before giving up.
-
-Interface specific settings
----------------------------
-
-In the directory /proc/sys/net/ipv4/conf you'll find one subdirectory for each
-interface the  system  knows about and one directory calls all. Changes in the
-all subdirectory  affect  all  interfaces,  whereas  changes  in  the  other
-subdirectories affect  only  one  interface.  All  directories  have  the same
-entries:
-
-accept_redirects
-----------------
-
-This switch  decides  if the kernel accepts ICMP redirect messages or not. The
-default is 'yes' if the kernel is configured for a regular host and 'no' for a
-router configuration.
-
-accept_source_route
--------------------
-
-Should source  routed  packages  be  accepted  or  declined.  The  default  is
-dependent on  the  kernel  configuration.  It's 'yes' for routers and 'no' for
-hosts.
-
-bootp_relay
-~~~~~~~~~~~
-
-Accept packets  with source address 0.b.c.d with destinations not to this host
-as local ones. It is supposed that a BOOTP relay daemon will catch and forward
-such packets.
-
-The default  is  0,  since this feature is not implemented yet (kernel version
-2.2.12).
-
-forwarding
-----------
-
-Enable or disable IP forwarding on this interface.
-
-log_martians
-------------
-
-Log packets with source addresses with no known route to kernel log.
-
-mc_forwarding
--------------
-
-Do multicast routing. The kernel needs to be compiled with CONFIG_MROUTE and a
-multicast routing daemon is required.
-
-proxy_arp
----------
-
-Does (1) or does not (0) perform proxy ARP.
-
-rp_filter
----------
-
-Integer value determines if a source validation should be made. 1 means yes, 0
-means no.  Disabled by default, but local/broadcast address spoofing is always
-on.
-
-If you  set this to 1 on a router that is the only connection for a network to
-the net,  it  will  prevent  spoofing  attacks  against your internal networks
-(external addresses  can  still  be  spoofed), without the need for additional
-firewall rules.
-
-secure_redirects
-----------------
-
-Accept ICMP  redirect  messages  only  for gateways, listed in default gateway
-list. Enabled by default.
-
-shared_media
-------------
-
-If it  is  not  set  the kernel does not assume that different subnets on this
-device can communicate directly. Default setting is 'yes'.
-
-send_redirects
---------------
-
-Determines whether to send ICMP redirects to other hosts.
-
-Routing settings
-----------------
-
-The directory  /proc/sys/net/ipv4/route  contains  several  file  to  control
-routing issues.
-
-error_burst and error_cost
---------------------------
-
-These  parameters  are used to limit how many ICMP destination unreachable to 
-send  from  the  host  in question. ICMP destination unreachable messages are 
-sent  when  we  cannot reach  the next hop while trying to transmit a packet. 
-It  will also print some error messages to kernel logs if someone is ignoring 
-our   ICMP  redirects.  The  higher  the  error_cost  factor  is,  the  fewer 
-destination  unreachable  and error messages will be let through. Error_burst 
-controls  when  destination  unreachable  messages and error messages will be
-dropped. The default settings limit warning messages to five every second.
-
-flush
------
-
-Writing to this file results in a flush of the routing cache.
-
-gc_elasticity, gc_interval, gc_min_interval_ms, gc_timeout, gc_thresh
----------------------------------------------------------------------
-
-Values to  control  the  frequency  and  behavior  of  the  garbage collection
-algorithm for the routing cache. gc_min_interval is deprecated and replaced
-by gc_min_interval_ms.
-
-
-max_size
---------
-
-Maximum size  of  the routing cache. Old entries will be purged once the cache
-reached has this size.
-
-redirect_load, redirect_number
-------------------------------
-
-Factors which  determine  if  more ICPM redirects should be sent to a specific
-host. No  redirects  will be sent once the load limit or the maximum number of
-redirects has been reached.
-
-redirect_silence
-----------------
-
-Timeout for redirects. After this period redirects will be sent again, even if
-this has been stopped, because the load or number limit has been reached.
-
-Network Neighbor handling
--------------------------
-
-Settings about how to handle connections with direct neighbors (nodes attached
-to the same link) can be found in the directory /proc/sys/net/ipv4/neigh.
-
-As we  saw  it  in  the  conf directory, there is a default subdirectory which
-holds the  default  values, and one directory for each interface. The contents
-of the  directories  are identical, with the single exception that the default
-settings contain additional options to set garbage collection parameters.
-
-In the interface directories you'll find the following entries:
-
-base_reachable_time, base_reachable_time_ms
--------------------------------------------
-
-A base  value  used for computing the random reachable time value as specified
-in RFC2461.
-
-Expression of base_reachable_time, which is deprecated, is in seconds.
-Expression of base_reachable_time_ms is in milliseconds.
-
-retrans_time, retrans_time_ms
------------------------------
-
-The time between retransmitted Neighbor Solicitation messages.
-Used for address resolution and to determine if a neighbor is
-unreachable.
-
-Expression of retrans_time, which is deprecated, is in 1/100 seconds (for
-IPv4) or in jiffies (for IPv6).
-Expression of retrans_time_ms is in milliseconds.
-
-unres_qlen
-----------
-
-Maximum queue  length  for a pending arp request - the number of packets which
-are accepted from other layers while the ARP address is still resolved.
-
-anycast_delay
--------------
-
-Maximum for  random  delay  of  answers  to  neighbor solicitation messages in
-jiffies (1/100  sec). Not yet implemented (Linux does not have anycast support
-yet).
-
-ucast_solicit
--------------
-
-Maximum number of retries for unicast solicitation.
-
-mcast_solicit
--------------
-
-Maximum number of retries for multicast solicitation.
-
-delay_first_probe_time
-----------------------
-
-Delay for  the  first  time  probe  if  the  neighbor  is  reachable.  (see
-gc_stale_time)
-
-locktime
---------
-
-An ARP/neighbor  entry  is only replaced with a new one if the old is at least
-locktime old. This prevents ARP cache thrashing.
-
-proxy_delay
------------
-
-Maximum time  (real  time is random [0..proxytime]) before answering to an ARP
-request for  which  we have an proxy ARP entry. In some cases, this is used to
-prevent network flooding.
-
-proxy_qlen
-----------
-
-Maximum queue length of the delayed proxy arp timer. (see proxy_delay).
-
-app_solicit
-----------
-
-Determines the  number of requests to send to the user level ARP daemon. Use 0
-to turn off.
-
-gc_stale_time
--------------
-
-Determines how  often  to  check  for stale ARP entries. After an ARP entry is
-stale it  will  be resolved again (which is useful when an IP address migrates
-to another  machine).  When  ucast_solicit is greater than 0 it first tries to
-send an  ARP  packet  directly  to  the  known  host  When  that  fails  and
-mcast_solicit is greater than 0, an ARP request is broadcasted.
-
-2.9 Appletalk
--------------
-
-The /proc/sys/net/appletalk  directory  holds the Appletalk configuration data
-when Appletalk is loaded. The configurable parameters are:
-
-aarp-expiry-time
-----------------
-
-The amount  of  time  we keep an ARP entry before expiring it. Used to age out
-old hosts.
-
-aarp-resolve-time
------------------
-
-The amount of time we will spend trying to resolve an Appletalk address.
-
-aarp-retransmit-limit
----------------------
-
-The number of times we will retransmit a query before giving up.
-
-aarp-tick-time
---------------
-
-Controls the rate at which expires are checked.
-
-The directory  /proc/net/appletalk  holds the list of active Appletalk sockets
-on a machine.
-
-The fields  indicate  the DDP type, the local address (in network:node format)
-the remote  address,  the  size of the transmit pending queue, the size of the
-received queue  (bytes waiting for applications to read) the state and the uid
-owning the socket.
-
-/proc/net/atalk_iface lists  all  the  interfaces  configured for appletalk.It
-shows the  name  of the interface, its Appletalk address, the network range on
-that address  (or  network number for phase 1 networks), and the status of the
-interface.
-
-/proc/net/atalk_route lists  each  known  network  route.  It lists the target
-(network) that the route leads to, the router (may be directly connected), the
-route flags, and the device the route is using.
-
-2.10 IPX
---------
-
-The IPX protocol has no tunable values in proc/sys/net.
-
-The IPX  protocol  does,  however,  provide  proc/net/ipx. This lists each IPX
-socket giving  the  local  and  remote  addresses  in  Novell  format (that is
-network:node:port). In  accordance  with  the  strange  Novell  tradition,
-everything but the port is in hex. Not_Connected is displayed for sockets that
-are not  tied to a specific remote address. The Tx and Rx queue sizes indicate
-the number  of  bytes  pending  for  transmission  and  reception.  The  state
-indicates the  state  the  socket  is  in and the uid is the owning uid of the
-socket.
-
-The /proc/net/ipx_interface  file lists all IPX interfaces. For each interface
-it gives  the network number, the node number, and indicates if the network is
-the primary  network.  It  also  indicates  which  device  it  is bound to (or
-Internal for  internal  networks)  and  the  Frame  Type if appropriate. Linux
-supports 802.3,  802.2,  802.2  SNAP  and DIX (Blue Book) ethernet framing for
-IPX.
-
-The /proc/net/ipx_route  table  holds  a list of IPX routes. For each route it
-gives the  destination  network, the router node (or Directly) and the network
-address of the router (or Connected) for internal networks.
-
-2.11 /proc/sys/fs/mqueue - POSIX message queues filesystem
-----------------------------------------------------------
-
-The "mqueue"  filesystem provides  the necessary kernel features to enable the
-creation of a  user space  library that  implements  the  POSIX message queues
-API (as noted by the  MSG tag in the  POSIX 1003.1-2001 version  of the System
-Interfaces specification.)
-
-The "mqueue" filesystem contains values for determining/setting  the amount of
-resources used by the file system.
-
-/proc/sys/fs/mqueue/queues_max is a read/write  file for  setting/getting  the
-maximum number of message queues allowed on the system.
-
-/proc/sys/fs/mqueue/msg_max  is  a  read/write file  for  setting/getting  the
-maximum number of messages in a queue value.  In fact it is the limiting value
-for another (user) limit which is set in mq_open invocation. This attribute of
-a queue must be less or equal then msg_max.
-
-/proc/sys/fs/mqueue/msgsize_max is  a read/write  file for setting/getting the
-maximum  message size value (it is every  message queue's attribute set during
-its creation).
+------------------------------------------------------------------------------
+CHAPTER 3: PER-PROCESS PARAMETERS
+------------------------------------------------------------------------------
 
-2.12 /proc/<pid>/oom_adj - Adjust the oom-killer score
+3.1 /proc/<pid>/oom_adj - Adjust the oom-killer score
 ------------------------------------------------------
 
 This file can be used to adjust the score used to select which processes
@@ -2066,25 +1062,15 @@ The task with the highest badness score 
 are killed, process itself will be killed in an OOM situation when it does
 not have children or some of them disabled oom like described above.
 
-2.13 /proc/<pid>/oom_score - Display current oom-killer score
+3.2 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 
-------------------------------------------------------------------------------
 This file can be used to check the current score used by the oom-killer is for
 any given <pid>. Use it together with /proc/<pid>/oom_adj to tune which
 process should be killed in an out-of-memory situation.
 
-------------------------------------------------------------------------------
-Summary
-------------------------------------------------------------------------------
-Certain aspects  of  kernel  behavior  can be modified at runtime, without the
-need to  recompile  the kernel, or even to reboot the system. The files in the
-/proc/sys tree  can  not only be read, but also modified. You can use the echo
-command to write value into these files, thereby changing the default settings
-of the kernel.
-------------------------------------------------------------------------------
 
-2.14  /proc/<pid>/io - Display the IO accounting fields
+3.3  /proc/<pid>/io - Display the IO accounting fields
 -------------------------------------------------------
 
 This file contains IO statistics for each running process
@@ -2186,7 +1172,7 @@ those 64-bit counters, process A could s
 More information about this can be found within the taskstats documentation in
 Documentation/accounting.
 
-2.15 /proc/<pid>/coredump_filter - Core dump filtering settings
+3.4 /proc/<pid>/coredump_filter - Core dump filtering settings
 ---------------------------------------------------------------
 When a process is dumped, all anonymous memory is written to a core file as
 long as the size of the core file isn't limited. But sometimes we don't want
@@ -2230,7 +1216,7 @@ For example:
   $ echo 0x7 > /proc/self/coredump_filter
   $ ./some_program
 
-2.16	/proc/<pid>/mountinfo - Information about mounts
+3.5	/proc/<pid>/mountinfo - Information about mounts
 --------------------------------------------------------
 
 This file contains lines of the form:
@@ -2267,30 +1253,3 @@ For more information on mount propagatio
 
   Documentation/filesystems/sharedsubtree.txt
 
-2.17	/proc/sys/fs/epoll - Configuration options for the epoll interface
---------------------------------------------------------
-
-This directory contains configuration options for the epoll(7) interface.
-
-max_user_instances
-------------------
-
-This is the maximum number of epoll file descriptors that a single user can
-have open at a given time. The default value is 128, and should be enough
-for normal users.
-
-max_user_watches
-----------------
-
-Every epoll file descriptor can store a number of files to be monitored
-for event readiness. Each one of these monitored files constitutes a "watch".
-This configuration option sets the maximum number of "watches" that are
-allowed for each user.
-Each "watch" costs roughly 90 bytes on a 32bit kernel, and roughly 160 bytes
-on a 64bit one.
-The current default value for  max_user_watches  is the 1/32 of the available
-low memory, divided for the "watch" cost in bytes.
-
-
-------------------------------------------------------------------------------
-
diff -puN Documentation/sysctl/00-INDEX~update-documentation-filesystem-proctxt-and-documentation-sysctls Documentation/sysctl/00-INDEX
--- a/Documentation/sysctl/00-INDEX~update-documentation-filesystem-proctxt-and-documentation-sysctls
+++ a/Documentation/sysctl/00-INDEX
@@ -10,6 +10,8 @@ fs.txt
 	- documentation for /proc/sys/fs/*.
 kernel.txt
 	- documentation for /proc/sys/kernel/*.
+net.txt
+	- documentation for /proc/sys/net/*.
 sunrpc.txt
 	- documentation for /proc/sys/sunrpc/*.
 vm.txt
diff -puN Documentation/sysctl/fs.txt~update-documentation-filesystem-proctxt-and-documentation-sysctls Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~update-documentation-filesystem-proctxt-and-documentation-sysctls
+++ a/Documentation/sysctl/fs.txt
@@ -1,5 +1,6 @@
 Documentation for /proc/sys/fs/*	kernel version 2.2.10
 	(c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+	(c) 2009,        Shen Feng<shen@cn.fujitsu.com>
 
 For general info and legal blurb, please look in README.
 
@@ -14,7 +15,12 @@ kernel. Since some of the files _can_ be
 system, it is advisable to read both documentation and source
 before actually making adjustments.
 
+1. /proc/sys/fs
+----------------------------------------------------------
+
 Currently, these files are in /proc/sys/fs:
+- aio-max-nr
+- aio-nr
 - dentry-state
 - dquot-max
 - dquot-nr
@@ -30,8 +36,15 @@ Currently, these files are in /proc/sys/
 - super-max
 - super-nr
 
-Documentation for the files in /proc/sys/fs/binfmt_misc is
-in Documentation/binfmt_misc.txt.
+==============================================================
+
+aio-nr & aio-max-nr:
+
+aio-nr is the running total of the number of events specified on the
+io_setup system call for all currently active aio contexts.  If aio-nr
+reaches aio-max-nr then io_setup will fail with EAGAIN.  Note that
+raising aio-max-nr does not result in the pre-allocation or re-sizing
+of any kernel data structures.
 
 ==============================================================
 
@@ -178,3 +191,60 @@ requests.  aio-max-nr allows you to chan
 aio-nr can grow to.
 
 ==============================================================
+
+
+2. /proc/sys/fs/binfmt_misc
+----------------------------------------------------------
+
+Documentation for the files in /proc/sys/fs/binfmt_misc is
+in Documentation/binfmt_misc.txt.
+
+
+3. /proc/sys/fs/mqueue - POSIX message queues filesystem
+----------------------------------------------------------
+
+The "mqueue"  filesystem provides  the necessary kernel features to enable the
+creation of a  user space  library that  implements  the  POSIX message queues
+API (as noted by the  MSG tag in the  POSIX 1003.1-2001 version  of the System
+Interfaces specification.)
+
+The "mqueue" filesystem contains values for determining/setting  the amount of
+resources used by the file system.
+
+/proc/sys/fs/mqueue/queues_max is a read/write  file for  setting/getting  the
+maximum number of message queues allowed on the system.
+
+/proc/sys/fs/mqueue/msg_max  is  a  read/write file  for  setting/getting  the
+maximum number of messages in a queue value.  In fact it is the limiting value
+for another (user) limit which is set in mq_open invocation. This attribute of
+a queue must be less or equal then msg_max.
+
+/proc/sys/fs/mqueue/msgsize_max is  a read/write  file for setting/getting the
+maximum  message size value (it is every  message queue's attribute set during
+its creation).
+
+
+4. /proc/sys/fs/epoll - Configuration options for the epoll interface
+--------------------------------------------------------
+
+This directory contains configuration options for the epoll(7) interface.
+
+max_user_instances
+------------------
+
+This is the maximum number of epoll file descriptors that a single user can
+have open at a given time. The default value is 128, and should be enough
+for normal users.
+
+max_user_watches
+----------------
+
+Every epoll file descriptor can store a number of files to be monitored
+for event readiness. Each one of these monitored files constitutes a "watch".
+This configuration option sets the maximum number of "watches" that are
+allowed for each user.
+Each "watch" costs roughly 90 bytes on a 32bit kernel, and roughly 160 bytes
+on a 64bit one.
+The current default value for  max_user_watches  is the 1/32 of the available
+low memory, divided for the "watch" cost in bytes.
+
diff -puN Documentation/sysctl/kernel.txt~update-documentation-filesystem-proctxt-and-documentation-sysctls Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~update-documentation-filesystem-proctxt-and-documentation-sysctls
+++ a/Documentation/sysctl/kernel.txt
@@ -1,5 +1,6 @@
 Documentation for /proc/sys/kernel/*	kernel version 2.2.10
 	(c) 1998, 1999,  Rik van Riel <riel@nl.linux.org>
+	(c) 2009,        Shen Feng<shen@cn.fujitsu.com>
 
 For general info and legal blurb, please look in README.
 
@@ -18,6 +19,7 @@ Currently, these files might (depending 
 show up in /proc/sys/kernel:
 - acpi_video_flags
 - acct
+- auto_msgmni
 - core_pattern
 - core_uses_pid
 - ctrl-alt-del
@@ -33,6 +35,7 @@ show up in /proc/sys/kernel:
 - msgmax
 - msgmnb
 - msgmni
+- nmi_watchdog
 - osrelease
 - ostype
 - overflowgid
@@ -40,6 +43,7 @@ show up in /proc/sys/kernel:
 - panic
 - pid_max
 - powersave-nap               [ PPC only ]
+- panic_on_unrecovered_nmi
 - printk
 - randomize_va_space
 - real-root-dev               ==> Documentation/initrd.txt
@@ -55,6 +59,7 @@ show up in /proc/sys/kernel:
 - sysrq                       ==> Documentation/sysrq.txt
 - tainted
 - threads-max
+- unknown_nmi_panic
 - version
 
 ==============================================================
@@ -381,3 +386,51 @@ can be ORed together:
  512 - A kernel warning has occurred.
 1024 - A module from drivers/staging was loaded.
 
+==============================================================
+
+auto_msgmni:
+
+Enables/Disables automatic recomputing of msgmni upon memory add/remove or
+upon ipc namespace creation/removal (see the msgmni description above).
+Echoing "1" into this file enables msgmni automatic recomputing.
+Echoing "0" turns it off.
+auto_msgmni default value is 1.
+
+==============================================================
+
+nmi_watchdog:
+
+Enables/Disables the NMI watchdog on x86 systems.  When the value is non-zero
+the NMI watchdog is enabled and will continuously test all online cpus to
+determine whether or not they are still functioning properly. Currently,
+passing "nmi_watchdog=" parameter at boot time is required for this function
+to work.
+
+If LAPIC NMI watchdog method is in use (nmi_watchdog=2 kernel parameter), the
+NMI watchdog shares registers with oprofile. By disabling the NMI watchdog,
+oprofile may have more registers to utilize.
+
+==============================================================
+
+unknown_nmi_panic:
+
+The value in this file affects behavior of handling NMI. When the value is
+non-zero, unknown NMI is trapped and then panic occurs. At that time, kernel
+debugging information is displayed on console.
+
+NMI switch that most IA32 servers have fires unknown NMI up, for example.
+If a system hangs up, try pressing the NMI switch.
+
+==============================================================
+
+panic_on_unrecovered_nmi:
+
+The default Linux behaviour on an NMI of either memory or unknown is to continue
+operation. For many environments such as scientific computing it is preferable
+that the box is taken out and the error dealt with than an uncorrected
+parity/ECC error get propogated.
+
+A small number of systems do generate NMI's for bizarre random reasons such as
+power management so the default is off. That sysctl works like the existing
+panic controls already in that directory.
+
diff -puN /dev/null Documentation/sysctl/net.txt
--- /dev/null
+++ a/Documentation/sysctl/net.txt
@@ -0,0 +1,174 @@
+Documentation for /proc/sys/net/*	kernel version 2.4.0-test11-pre4
+	(c) 1999		Terrehon Bowden <terrehon@pacbell.net>
+				Bodo Bauer <bb@ricochet.net>
+	(c) 2000		Jorge Nerin <comandante@zaralinux.com>
+	(c) 2009		Shen Feng <shen@cn.fujitsu.com>
+
+For general info and legal blurb, please look in README.
+
+==============================================================
+
+This file contains the documentation for the sysctl files in
+/proc/sys/net and is valid for Linux kernel version 2.4.0-test11-pre4.
+
+The interface  to  the  networking  parts  of  the  kernel  is  located  in
+/proc/sys/net. The following table shows all possible subdirectories.You may
+see only some of them, depending on your kernel's configuration.
+
+
+Table : Subdirectories in /proc/sys/net
+..............................................................................
+ Directory Content             Directory  Content
+ core      General parameter   appletalk  Appletalk protocol
+ unix      Unix domain sockets netrom     NET/ROM
+ 802       E802 protocol       ax25       AX25
+ ethernet  Ethernet protocol   rose       X.25 PLP layer
+ ipv4      IP version 4        x25        X.25 protocol
+ ipx       IPX                 token-ring IBM token ring
+ bridge    Bridging            decnet     DEC net
+ ipv6      IP version 6
+..............................................................................
+
+1. /proc/sys/net/core - Network core options
+-------------------------------------------------------
+
+rmem_default
+------------
+
+The default setting of the socket receive buffer in bytes.
+
+rmem_max
+--------
+
+The maximum receive socket buffer size in bytes.
+
+wmem_default
+------------
+
+The default setting (in bytes) of the socket send buffer.
+
+wmem_max
+--------
+
+The maximum send socket buffer size in bytes.
+
+message_burst and message_cost
+------------------------------
+
+These parameters  are used to limit the warning messages written to the kernel
+log from  the  networking  code.  They  enforce  a  rate  limit  to  make  a
+denial-of-service attack  impossible. A higher message_cost factor, results in
+fewer messages that will be written. Message_burst controls when messages will
+be dropped.  The  default  settings  limit  warning messages to one every five
+seconds.
+
+warnings
+--------
+
+This controls console messages from the networking stack that can occur because
+of problems on the network like duplicate address or bad checksums. Normally,
+this should be enabled, but if the problem persists the messages can be
+disabled.
+
+netdev_budget
+-------------
+
+Maximum number of packets taken from all interfaces in one polling cycle (NAPI
+poll). In one polling cycle interfaces which are registered to polling are
+probed in a round-robin manner. The limit of packets in one such probe can be
+set per-device via sysfs class/net/<device>/weight .
+
+netdev_max_backlog
+------------------
+
+Maximum number  of  packets,  queued  on  the  INPUT  side, when the interface
+receives packets faster than kernel can process them.
+
+optmem_max
+----------
+
+Maximum ancillary buffer size allowed per socket. Ancillary data is a sequence
+of struct cmsghdr structures with appended data.
+
+2. /proc/sys/net/unix - Parameters for Unix domain sockets
+-------------------------------------------------------
+
+There are  only  two  files  in this subdirectory. They control the delays for
+deleting and destroying socket descriptors.
+
+
+3. /proc/sys/net/ipv4 - IPV4 settings
+-------------------------------------------------------
+Please see: Documentation/networking/ip-sysctl.txt and ipvs-sysctl.txt for
+descriptions of these entries.
+
+
+4. Appletalk
+-------------------------------------------------------
+
+The /proc/sys/net/appletalk  directory  holds the Appletalk configuration data
+when Appletalk is loaded. The configurable parameters are:
+
+aarp-expiry-time
+----------------
+
+The amount  of  time  we keep an ARP entry before expiring it. Used to age out
+old hosts.
+
+aarp-resolve-time
+-----------------
+
+The amount of time we will spend trying to resolve an Appletalk address.
+
+aarp-retransmit-limit
+---------------------
+
+The number of times we will retransmit a query before giving up.
+
+aarp-tick-time
+--------------
+
+Controls the rate at which expires are checked.
+
+The directory  /proc/net/appletalk  holds the list of active Appletalk sockets
+on a machine.
+
+The fields  indicate  the DDP type, the local address (in network:node format)
+the remote  address,  the  size of the transmit pending queue, the size of the
+received queue  (bytes waiting for applications to read) the state and the uid
+owning the socket.
+
+/proc/net/atalk_iface lists  all  the  interfaces  configured for appletalk.It
+shows the  name  of the interface, its Appletalk address, the network range on
+that address  (or  network number for phase 1 networks), and the status of the
+interface.
+
+/proc/net/atalk_route lists  each  known  network  route.  It lists the target
+(network) that the route leads to, the router (may be directly connected), the
+route flags, and the device the route is using.
+
+
+5. IPX
+-------------------------------------------------------
+
+The IPX protocol has no tunable values in proc/sys/net.
+
+The IPX  protocol  does,  however,  provide  proc/net/ipx. This lists each IPX
+socket giving  the  local  and  remote  addresses  in  Novell  format (that is
+network:node:port). In  accordance  with  the  strange  Novell  tradition,
+everything but the port is in hex. Not_Connected is displayed for sockets that
+are not  tied to a specific remote address. The Tx and Rx queue sizes indicate
+the number  of  bytes  pending  for  transmission  and  reception.  The  state
+indicates the  state  the  socket  is  in and the uid is the owning uid of the
+socket.
+
+The /proc/net/ipx_interface  file lists all IPX interfaces. For each interface
+it gives  the network number, the node number, and indicates if the network is
+the primary  network.  It  also  indicates  which  device  it  is bound to (or
+Internal for  internal  networks)  and  the  Frame  Type if appropriate. Linux
+supports 802.3,  802.2,  802.2  SNAP  and DIX (Blue Book) ethernet framing for
+IPX.
+
+The /proc/net/ipx_route  table  holds  a list of IPX routes. For each route it
+gives the  destination  network, the router node (or Directly) and the network
+address of the router (or Connected) for internal networks.
_

Patches currently in -mm which might be from shen@cn.fujitsu.com are

update-documentation-filesystem-proctxt-and-documentation-sysctls.patch

