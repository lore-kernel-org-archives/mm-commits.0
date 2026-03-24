Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBD03596E1
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388499; cv=none; b=cmUH19rbFrvMoLsJzoPbxEIwTF1Zyrumd2lHju5jqBMXVWmpj927IsEuRF6TfdoNdv9+0mJLwdAwtBt0p6n9lV4wC/u/HqJX4lxJMi+Lmbi/sNozS2CdhqYE8e6oHQSLjm2oz4AEj92JMk34h7URNU2j+P9SbP+d3gysWWdGorU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388499; c=relaxed/simple;
	bh=iH/4e2Sk8KYmwGqWR1ba6FXQXnYjKLqj0M2Y9mulJOs=;
	h=Date:To:From:Subject:Message-Id; b=RnAE0fVR6TS+qwyfBW/bVzP+JyCfam38/1K+CVPnYh1HugqXxJWrQ0ReGULVdSY1VEglfUxPtRCq9IhSl5d9jIRRTDKfqPQM2kTMiwUlib8c7lASl9u9HGyhoJvXp77dSbzlX127EB2RSy+ShvJL/vQkUH4YNxStsPaDjHy1yE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=azx96aA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="azx96aA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2CCC19424;
	Tue, 24 Mar 2026 21:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388499;
	bh=iH/4e2Sk8KYmwGqWR1ba6FXQXnYjKLqj0M2Y9mulJOs=;
	h=Date:To:From:Subject:From;
	b=azx96aA79K10sFzzw/umcYUEBsq2LpM/A6mopFGKCYi7q/1ft8yzbISzvZFxxQ0Z3
	 64QZenWBrTr92USz6We0SAn7sLt/LOMXhU6PzRmWQ/DAuNq5miJNCi/uUVdjCmHyMZ
	 EExUi5uIAY4rkeal2iNIBWpfMqd3krokFJU8n69g=
Date: Tue, 24 Mar 2026 14:41:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-correct-right-ma_wr_state-end-pivot-in-mas_wr_spanning_store.patch removed from -mm tree
Message-Id: <20260324214139.0A2CCC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: correct right ma_wr_state end pivot in mas_wr_spanning_store()
has been removed from the -mm tree.  Its filename was
     maple_tree-correct-right-ma_wr_state-end-pivot-in-mas_wr_spanning_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: correct right ma_wr_state end pivot in mas_wr_spanning_store()
Date: Fri, 30 Jan 2026 15:59:15 -0500

The end_piv will be needed in the next patch set and has not been set
correctly in this code path.  Correct the oversight before using it.

Link: https://lkml.kernel.org/r/20260130205935.2559335-11-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c~maple_tree-correct-right-ma_wr_state-end-pivot-in-mas_wr_spanning_store
+++ a/lib/maple_tree.c
@@ -3494,6 +3494,7 @@ static void mas_wr_spanning_store(struct
 	r_mas.index = r_mas.last;
 	mas_wr_walk_index(&r_wr_mas);
 	r_mas.last = r_mas.index = mas->last;
+	r_wr_mas.end_piv = r_wr_mas.r_max;
 
 	/* Set up left side. */
 	mas_wr_walk_index(wr_mas);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


