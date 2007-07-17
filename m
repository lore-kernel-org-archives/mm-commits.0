From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-build-rpcsec_gss-whenever-nfsd4-is-built.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:42 -0700
Message-ID: <200707172304.l6HN4gP6011826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936458AbXGQXP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: build rpcsec_gss whenever nfsd4 is built
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-build-rpcsec_gss-whenever-nfsd4-is-built.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: build rpcsec_gss whenever nfsd4 is built
From: J. Bruce Fields <bfields@citi.umich.edu>

Select rpcsec_gss support whenever asked for NFSv4 support.  The rfc actually
requires gss, and gss is also the main reason to migrate to v4.  We already do
this on the client side.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/Kconfig~knfsd-nfsd4-build-rpcsec_gss-whenever-nfsd4-is-built fs/Kconfig
--- a/fs/Kconfig~knfsd-nfsd4-build-rpcsec_gss-whenever-nfsd4-is-built
+++ a/fs/Kconfig
@@ -1675,6 +1675,7 @@ config NFSD_V3_ACL
 config NFSD_V4
 	bool "Provide NFSv4 server support (EXPERIMENTAL)"
 	depends on NFSD_V3 && EXPERIMENTAL
+	select RPCSEC_GSS_KRB5
 	help
 	  If you would like to include the NFSv4 server as well as the NFSv2
 	  and NFSv3 servers, say Y here.  This feature is experimental, and
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
