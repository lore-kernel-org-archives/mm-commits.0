From: akpm@linux-foundation.org
Subject: - updates-to-nfsroot-documentation-take-3.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:39:23 -0800
Message-ID: <200712172339.lBHNdNUU008121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46619 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757734AbXLQXjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:39:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@us.ibm.com, ak@suse.de, davem@davemloft.net, horms@verge.net.au, mm-commits@vger.kernel.org


The patch titled
     Updates to nfsroot documentation
has been removed from the -mm tree.  Its filename was
     updates-to-nfsroot-documentation-take-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Updates to nfsroot documentation
From: Amos Waterland <apw@us.ibm.com>

The difference between ip=off and ip=::::::off has been a cause of much
confusion.  Document how each behaves, and do not contradict ourselves by
saying that "off" is the default when in fact "any" is the default and is
descibed as being so lower in the file.

Signed-off-by: Amos Waterland <apw@us.ibm.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/nfsroot.txt |   12 +++++++++---
 net/ipv4/ipconfig.c       |   20 +-------------------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff -puN Documentation/nfsroot.txt~updates-to-nfsroot-documentation-take-3 Documentation/nfsroot.txt
--- a/Documentation/nfsroot.txt~updates-to-nfsroot-documentation-take-3
+++ a/Documentation/nfsroot.txt
@@ -92,8 +92,14 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netm
   autoconfiguration.
 
   The <autoconf> parameter can appear alone as the value to the `ip'
-  parameter (without all the ':' characters before) in which case auto-
-  configuration is used.
+  parameter (without all the ':' characters before).  If the value is
+  "ip=off" or "ip=none", no autoconfiguration will take place, otherwise
+  autoconfiguration will take place.  The most common way to use this
+  is "ip=dhcp".
+
+  Note that "ip=off" is not the same thing as "ip=::::::off", because in
+  the latter autoconfiguration will take place if any of DHCP, BOOTP or RARP
+  are compiled in the kernel.
 
   <client-ip>	IP address of the client.
 
@@ -142,7 +148,7 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netm
 		into the kernel will be used, regardless of the value of
 		this option.
 
-                  off or none: don't use autoconfiguration (default)
+                  off or none: don't use autoconfiguration
 		  on or any:   use any protocol available in the kernel
 		  dhcp:        use DHCP
 		  bootp:       use BOOTP
diff -puN net/ipv4/ipconfig.c~updates-to-nfsroot-documentation-take-3 net/ipv4/ipconfig.c
--- a/net/ipv4/ipconfig.c~updates-to-nfsroot-documentation-take-3
+++ a/net/ipv4/ipconfig.c
@@ -1410,25 +1410,7 @@ late_initcall(ip_auto_config);
 
 /*
  *  Decode any IP configuration options in the "ip=" or "nfsaddrs=" kernel
- *  command line parameter. It consists of option fields separated by colons in
- *  the following order:
- *
- *  <client-ip>:<server-ip>:<gw-ip>:<netmask>:<host name>:<device>:<PROTO>
- *
- *  Any of the fields can be empty which means to use a default value:
- *	<client-ip>	- address given by BOOTP or RARP
- *	<server-ip>	- address of host returning BOOTP or RARP packet
- *	<gw-ip>		- none, or the address returned by BOOTP
- *	<netmask>	- automatically determined from <client-ip>, or the
- *			  one returned by BOOTP
- *	<host name>	- <client-ip> in ASCII notation, or the name returned
- *			  by BOOTP
- *	<device>	- use all available devices
- *	<PROTO>:
- *	   off|none	    - don't do autoconfig at all (DEFAULT)
- *	   on|any           - use any configured protocol
- *	   dhcp|bootp|rarp  - use only the specified protocol
- *	   both             - use both BOOTP and RARP (not DHCP)
+ *  command line parameter.  See Documentation/nfsroot.txt.
  */
 static int __init ic_proto_name(char *name)
 {
_

Patches currently in -mm which might be from apw@us.ibm.com are

origin.patch
