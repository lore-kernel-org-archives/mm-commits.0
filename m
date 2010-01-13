From: akpm@linux-foundation.org
Subject: + fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch added to -mm tree
Date: Wed, 13 Jan 2010 12:54:37 -0800
Message-ID: <201001132054.o0DKsbnx027883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755943Ab0AMUyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 15:54:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, joel.becker@oracle.com, mfasheh@suse.com


The patch titled
     fs/ocfs2/cluster/tcp.c: remove use of NIPQUAD, use %pI4
has been added to the -mm tree.  Its filename is
     fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch

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
Subject: fs/ocfs2/cluster/tcp.c: remove use of NIPQUAD, use %pI4
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4 fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4
+++ a/fs/ocfs2/cluster/tcp.c
@@ -72,9 +72,9 @@
 
 #include "tcp_internal.h"
 
-#define SC_NODEF_FMT "node %s (num %u) at %u.%u.%u.%u:%u"
+#define SC_NODEF_FMT "node %s (num %u) at %pI4:%u"
 #define SC_NODEF_ARGS(sc) sc->sc_node->nd_name, sc->sc_node->nd_num,	\
-			  NIPQUAD(sc->sc_node->nd_ipv4_address),	\
+			  &sc->sc_node->nd_ipv4_address,		\
 			  ntohs(sc->sc_node->nd_ipv4_port)
 
 /*
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch

