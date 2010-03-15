From: akpm@linux-foundation.org
Subject: [merged] fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:52:30 -0400
Message-ID: <201003150653.o2F6r4eT015969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COGxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, joel.becker@oracle.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     fs/ocfs2/cluster/tcp.c: remove use of NIPQUAD, use %pI4
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ocfs2/cluster/tcp.c: remove use of NIPQUAD, use %pI4
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <joel.becker@oracle.com>
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

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

