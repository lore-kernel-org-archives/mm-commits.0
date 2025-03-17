Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF97221ABC8
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 07:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742195162; cv=none; b=X94ZYgMMD5uUQJQXCQ3lrJ1RiasPIaY5VJTHHuQWouJBdtFVa3FvKEdYGb+AXff7V38Cku2eAFMImYfQWvzG97uP56It27Xfrv3vEmzI5wygL1NajSlEvKEPCBYMHWVxqKw/iVNxkhXlNiXvYQGEjoaGpaiODr2AcS8rergs8/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742195162; c=relaxed/simple;
	bh=m8PmWQt2rt2NxQLRJ0Zf0Ijrvnyu8zMCNat8bSPYn40=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cd1+gji5pFWxAM8Hr22EP6OOKQ2Rs4XV/2r7FJPATgV58oXAZ9afMuzlaUUQ2OtQmqySJwhJgpgFDKQTkpsE2dOWztUzbviUCQsAMbS0ocDZpo9Ykd+V779dpqepAb47RSTHpVcOL8TvcHhmXhuNIKw849rxqV4lXokFr3Y4SlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=agl9vJO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="agl9vJO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8B5C4CEE3;
	Mon, 17 Mar 2025 07:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742195161;
	bh=m8PmWQt2rt2NxQLRJ0Zf0Ijrvnyu8zMCNat8bSPYn40=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=agl9vJO5rTIad3tST/DULUgr/JXZ3NZPgN3vtbsPIKtzguFuItyvGH5Vpltn4SzHt
	 dTvwKXD9YFXtXI2u2RrVe9mxvBvX7K1U6BcrDnH/gzyJ2PKxWdj4qaSgVZGWSnQNEV
	 fmfVfl/BQmWFkV6idQ4l7qrEYkBxHKWHe7+3DVBk=
Date: Mon, 17 Mar 2025 00:06:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <mm-commits@vger.kernel.org>, <osalvador@suse.de>,
 <muchun.song@linux.dev>, <mel@csn.ul.ie>, <lee.schermerhorn@hp.com>,
 <david@redhat.com>, <andi@firstfloor.org>
Subject: Re: [merged mm-stable]
 mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch
 removed from -mm tree
Message-Id: <20250317000600.3f01e3a8fab33f3753ae1abe@linux-foundation.org>
In-Reply-To: <9f0e1e9d-2c91-6204-4907-f5c2c5bb2e93@huawei.com>
References: <20250317051437.4085FC4CEEC@smtp.kernel.org>
	<9f0e1e9d-2c91-6204-4907-f5c2c5bb2e93@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 17 Mar 2025 14:29:03 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> 
> 在 2025/3/17 13:14, Andrew Morton 写道:
> > The quilt patch titled
> >       Subject: mm/hugetlb: fix set_max_huge_pages() when there are surplus pages
> > has been removed from the -mm tree.  Its filename was
> >       mm-hugetlb-fix-set_max_huge_pages-when-there-are-surplus-pages.patch
> >
> > This patch was dropped because it was merged into the mm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Hi, Andrew
> 
> As I explained in https://lore.kernel.org/all/c2c3d8b5-4b99-220e-20e0-e4a9dd8f5ecf@huawei.com/,
> This patch fails to deal with free surplus huge pages, and will introduce another issue.
> 
> So please drop this patch from mm tree.

OK, thanks, dropped.
