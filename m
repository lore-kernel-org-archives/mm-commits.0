From: akpm@linux-foundation.org
Subject: + docsrc-fix-ifenslave-type.patch added to -mm tree
Date: Tue, 29 Jul 2008 17:31:32 -0700
Message-ID: <200807300031.m6U0VXZB030212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbYG3Acf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 20:32:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, davem@davemloft.net, sam@ravnborg.org


The patch titled
     docsrc: fix ifenslave type
has been added to the -mm tree.  Its filename is
     docsrc-fix-ifenslave-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docsrc: fix ifenslave type
From: Randy Dunlap <randy.dunlap@oracle.com>

Documentation/networking/ifenslave.c:1084: warning: pointer targets in assignment differ in signedness

From include/linux/socket.h:
 *	1003.1g requires sa_family_t and that sa_data is char.

and from SUSv3:
(http://www.opengroup.org/onlinepubs/009695399/basedefs/sys/socket.h.html)

The <sys/socket.h> header shall define the sockaddr structure that includes at least the following members:

sa_family_t  sa_family  Address family.
char         sa_data[]  Socket address (variable-length data).
<end SUSv3>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/networking/ifenslave.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/networking/ifenslave.c~docsrc-fix-ifenslave-type Documentation/networking/ifenslave.c
--- a/Documentation/networking/ifenslave.c~docsrc-fix-ifenslave-type
+++ a/Documentation/networking/ifenslave.c
@@ -1081,7 +1081,7 @@ static int set_if_addr(char *master_ifna
 
 		}
 
-		ipaddr = ifr.ifr_addr.sa_data;
+		ipaddr = (unsigned char *)ifr.ifr_addr.sa_data;
 		v_print("Interface '%s': set IP %s to %d.%d.%d.%d\n",
 			slave_ifname, ifra[i].desc,
 			ipaddr[0], ipaddr[1], ipaddr[2], ipaddr[3]);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
v4l-fix-kernel-doc-warning-function-name-and-docbook-filename.patch
documentation-build-source-files-in-documentation-sub-dir.patch
genksyms-parser-fix-the-__attribute__-rule.patch
genksyms-include-extern-information-in-dumps.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
docsrc-fix-procfs-example.patch
docsrc-fix-ifenslave-type.patch
docsrc-fix-crc32hash-type.patch
docsrc-fix-getdelays-printk-formats.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works-comment.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

