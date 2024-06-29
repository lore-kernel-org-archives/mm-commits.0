Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E2D816
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627658; cv=none; b=ImuEb54IezzMwjbMAyUf3Wwt25hcd7IiurED3s5jl+PhhHOi4L/pgJB2TFgRXevhQU9zryo4Cep8dz6R52LpBCmvxmStjw/G2ZTxH/NfH22sjZA8f6E9an/RQXuJUTfz2OBKybk1Q9ThwPKD3cp6o/DC5dBc9Acz6mtY3hYCeVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627658; c=relaxed/simple;
	bh=c4viw+XZfTwPmalo4PfwDSoIa8315g+qGoXwXNjPc5U=;
	h=Date:To:From:Subject:Message-Id; b=tvDb51Y+I9pEtnGSDraOVbRyocWL/UlciK21wxbY8JRWn56C0imSCOLf6F6Dr0nhycYWV9HBuagEq75IrZ0VvQCYrhy2umMJsASaSSwj7ubr5XFoob8TG1IDQqOfGVFFX+2drhcNfQX1/1h1eS2Ui9r+5oVAVcC4KJwjx6Fsf2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q1uCWbyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q1uCWbyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF79C116B1;
	Sat, 29 Jun 2024 02:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627658;
	bh=c4viw+XZfTwPmalo4PfwDSoIa8315g+qGoXwXNjPc5U=;
	h=Date:To:From:Subject:From;
	b=q1uCWbyYeNGuNSg3w3XoJKDxrvPee82w6ut6ybiGmJc9sEPFch1tHaEUVJ/0jfABY
	 zWboxuioml83AeRkvTA6XGMZRc3ld6ocQjrJl+3mDXLoMn/ArSZ+40LfK63GTcBNyp
	 CWP7GBcc2kIOgTOEYohASo4UF8yud3GCh9xPCo7w=
Date: Fri, 28 Jun 2024 19:20:58 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,lkp@intel.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch removed from -mm tree
Message-Id: <20240629022058.9DF79C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix the missing doc for flags of folio_add_new_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2.patch

This patch was dropped because it was folded into mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: fix the missing doc for flags of folio_add_new_anon_rmap()
Date: Thu, 20 Jun 2024 08:57:55 +1200

Fix mm/rmap.c:1413: warning: Function parameter or struct member
'flags' not described in 'folio_add_new_anon_rmap'.

Link: https://lkml.kernel.org/r/20240619210641.62542-1-21cnbao@gmail.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406200059.tVU9semU-lkp@intel.com/
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/rmap.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-2
+++ a/mm/rmap.c
@@ -1401,6 +1401,7 @@ void folio_add_anon_rmap_pmd(struct foli
  * @folio:	The folio to add the mapping to.
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
+ * @flags:	The rmap flags
  *
  * Like folio_add_anon_rmap_*() but must only be called on *new* folios.
  * This means the inc-and-test can be bypassed.
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix-3.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix-2.patch
mm-remove-folio_test_anonfolio==false-path-in-__folio_add_anon_rmap.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch

