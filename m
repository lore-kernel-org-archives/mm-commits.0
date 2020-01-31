From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 058/118] tools/vm/slabinfo: fix sanity checks
 enabling
Date: Thu, 30 Jan 2020 22:14:17 -0800
Message-ID: <20200131061417.tqdPF1W2m%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGOS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:14:18 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, dwagner@suse.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, tobin@kernel.org, torvalds@linux-foundation.org

From: Daniel Wagner <dwagner@suse.de>
Subject: tools/vm/slabinfo: fix sanity checks enabling

The sysfs file name for enabling sanity checking is called 'sanity_checks'
and not 'sanity'.

The name of the file has never changed since the introduction of the slub
allocator.  Obviously, most people turn the checks on via the command line
option and not during runtime using slabinfo.

Link: http://lkml.kernel.org/r/20200116131642.642-1-dwagner@suse.de
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-fix-sanity-checks-enabling
+++ a/tools/vm/slabinfo.c
@@ -720,11 +720,11 @@ static void slab_debug(struct slabinfo *
 		return;
 
 	if (sanity && !s->sanity_checks) {
-		set_obj(s, "sanity", 1);
+		set_obj(s, "sanity_checks", 1);
 	}
 	if (!sanity && s->sanity_checks) {
 		if (slab_empty(s))
-			set_obj(s, "sanity", 0);
+			set_obj(s, "sanity_checks", 0);
 		else
 			fprintf(stderr, "%s not empty cannot disable sanity checks\n", s->name);
 	}
_
