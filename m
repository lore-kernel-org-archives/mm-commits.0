Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC412BAF9
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 06:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720766742; cv=none; b=kh14yT/Ssb2pG2u9yIX1IRPQAwNlS/0vipIJwv4x4pMFRfN3NhgTxMIsbwSyOVjhThbwDdaqLwBSFPJp2/h2Abs2j7EqEj1GBcUelvUkaFOYCXXE1p3TQthBJfqfz4UiuBAlH0XyD6/blQx6PFzgLe8BgY1aEiLdkVeg2+0mkV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720766742; c=relaxed/simple;
	bh=V8XdVf6BVVEBxD3c7D8YukRTQiXpEYD+NHpNkB41u1g=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=aWxf+koyVhodtfEFOuR+yx+HacGA5A37DUAItlNhmatLNr3s5/xe+5z/DLiBxiZ/R0RGn90kPLfT21q3yLCElcPTenSd24YVYTEC8WhKTXaTsflpR878Y3Yu+IgRPx5i4ikZXNWBEwgXl+eCkzwy++HCd1f3IMl4eULV6hx7UEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYGYfDjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYGYfDjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFD1C3277B;
	Fri, 12 Jul 2024 06:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720766742;
	bh=V8XdVf6BVVEBxD3c7D8YukRTQiXpEYD+NHpNkB41u1g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dYGYfDjhwc3aW2mXDlHwPfoceQcH3VSl8UQHP92ntscc6676X16lMzlbU4x4WVKIu
	 d26mCOZN8otd/qD8RId1eVBcctvKJVvmor5Xatm4nZwfIdmtHhd6a21gI/Hvp1rtQ3
	 5HANwDKMFRBcC3QEYKNX8li5ZxD3DloOVsfMoJDA=
Date: Thu, 11 Jul 2024 23:45:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Aristeu Rozanski <aris@redhat.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, mm-commits@vger.kernel.org
Subject: Re: mm.git: a small error in mm-stable
Message-Id: <20240711234541.f17a36ca85734e8106c18da4@linux-foundation.org>
In-Reply-To: <85b0d694-d1ac-8e7a-2e50-1edc03eee21a@google.com>
References: <85b0d694-d1ac-8e7a-2e50-1edc03eee21a@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Jul 2024 20:30:07 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> In looking through a "git log -p --reverse v6.10-rc6..HEAD"
> of mm-everything, I just noticed a small anomaly in mm-stable:
> ac90c56bbd73 "mm/ksm: refactor out try_to_merge_with_zero_page()"
> modifies mm/hugetlb.c! undoing a oneliner which had been folded-merged into
> 003af997c8a9 "hugetlb: force allocating surplus hugepages on mempolicy allowed nodes"
> which comes just before it.
> 

Huh thanks.  This cycle has been pretty bad with new hotfixes coming in
and messing up mm-stable.

--- a/mm/hugetlb.c~mm-hugetlbc-undo-errant-change
+++ a/mm/hugetlb.c
@@ -2634,6 +2634,7 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
+		folio = NULL;
 		for_each_node_mask(node, cpuset_current_mems_allowed) {
 			if (!mbind_nodemask || node_isset(node, *mbind_nodemask)) {
 				folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
_

