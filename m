From: akpm@linux-foundation.org
Subject: - add-missing-data_data-in-powerpc.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:09:31 -0700
Message-ID: <200707172309.l6HN9VWt012374__27052.5203356103$1184714225$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936388AbXGQXPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, linuxppc-dev@ozlabs.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: add missing DATA_DATA
has been removed from the -mm tree.  Its filename was
     add-missing-data_data-in-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: add missing DATA_DATA
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: <paulus@samba.org>
Cc: <linuxppc-dev@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vmlinux.lds.S |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/vmlinux.lds.S~add-missing-data_data-in-powerpc arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S~add-missing-data_data-in-powerpc
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -174,7 +174,9 @@ SECTIONS
 	}
 #else
 	.data : {
-		*(.data .data.rel* .toc1)
+		DATA_DATA
+		*(.data.rel*)
+		*(.toc1)
 		*(.branch_lt)
 	}
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-kbuild.patch
