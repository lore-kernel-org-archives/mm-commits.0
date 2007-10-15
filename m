From: akpm@linux-foundation.org
Subject: + ipv4-kernel-panic-when-only-one-unsecured-port-available.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:49:23 -0700
Message-ID: <200710151949.l9FJnSlC021810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932657AbXJOT4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarapov@redhat.com, davem@davemloft.net


The patch titled
     ipv4: kernel panic when only one unsecured port available
has been added to the -mm tree.  Its filename is
     ipv4-kernel-panic-when-only-one-unsecured-port-available.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipv4: kernel panic when only one unsecured port available
From: Anton Arapov <aarapov@redhat.com>

Steps to reproduce:
Server:
  [root@server ~]# cat /etc/exports
  /export *(ro,insecure)
// there is insecure ... I am using ports like "1024 to 61000"
  [root@server ~] service nfs restart 

Client:
  1.[root@client ~]# echo 32768 32768 > /proc/sys/net/ipv4/ip_local_port_range
  32768   32768
// two same numbers, for ex "32769 32769" etc.
  2.[root@client ~]# cat /proc/sys/net/ipv4/ip_local_port_range
  32768   32768
  3.[root@client ~]# mount server:/export /import
  
Actual results:
  Kernel always panics 

Patch prevents division by zero.  Kernel panics if only one unsecured port
available.

Signed-off-by: Anton Arapov <aarapov@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/inet_connection_sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ipv4/inet_connection_sock.c~ipv4-kernel-panic-when-only-one-unsecured-port-available net/ipv4/inet_connection_sock.c
--- a/net/ipv4/inet_connection_sock.c~ipv4-kernel-panic-when-only-one-unsecured-port-available
+++ a/net/ipv4/inet_connection_sock.c
@@ -93,7 +93,7 @@ int inet_csk_get_port(struct inet_hashin
 		int remaining, rover, low, high;
 
 		inet_get_local_port_range(&low, &high);
-		remaining = high - low;
+		remaining = high - low + 1;
 		rover = net_random() % remaining + low;
 
 		do {
_

Patches currently in -mm which might be from aarapov@redhat.com are

ipv4-kernel-panic-when-only-one-unsecured-port-available.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
