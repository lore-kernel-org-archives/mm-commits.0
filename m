Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88981C700D
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 19:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750101569; cv=none; b=LR43J7Hf72RvWA9reNcGlmyRY8DSJQXKvPsGE7S5qNVxpkBHlCyfVqUPl3JJRvsdKyIxOfApijyvoJDaZ2Ig99uEcdsbdBbHOGGT6gKBzcb6BwnZ0rtvtT7xqkfK9MPdIk6Qm3ZSTqiXfSQtev35AiIYvOO2kGBl3vRqTbtmhmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750101569; c=relaxed/simple;
	bh=4cwnlxwYCzW+5ZEoBFPdWrksVUAE21tMWMLwvrX8ueo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=iQ1EbsdBfjRGHu0ZtE24vW7DF2MPZtIADzLp5OWtj45+q7ZmmwXk11Y3+cr+KiL+QYg/78F5F8fIqFUUpxkq3gIyOoyWQ1yS43QnHZ/gkgZCWlnzVuviVT+kGq9CaoyQd4tVr+ASkbBGTOb3wiMvPpK76GfAtUeX1Yz2uQR6XJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u/olLl33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u/olLl33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3FAC4CEEA;
	Mon, 16 Jun 2025 19:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750101569;
	bh=4cwnlxwYCzW+5ZEoBFPdWrksVUAE21tMWMLwvrX8ueo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=u/olLl33HYL4UXOWdNqyA6+TLxnVhYHpNWQ+Bgyo2shcFXY/GnssPMtbanwzLbbH0
	 FP+MUnue3Ubohd4fAock0MSpKjzPG0EgG81j5AF1fJt3auYICsR7Jx697j53u+xS/u
	 XSGzJ+cv8a2g9LS+1/pDInnqnptWO1a/McdBJ94A=
Date: Mon, 16 Jun 2025 12:19:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
 pulehui@huawei.com, lorenzo.stoakes@oracle.com, liam.howlett@oracle.com,
 jannh@google.com, broonie@kernel.org, aishwarya.tcv@arm.com
Subject: Re: +
 selftests-mm-skip-uprobe-vma-merge-test-if-uprobes-are-not-enabled.patch
 added to mm-new branch
Message-Id: <20250616121928.a14de3ab5ebb384b329f78e3@linux-foundation.org>
In-Reply-To: <mfcsekeqtzsoqubme6rawl6hntgchjq6nr2bzwrty2rubahpja@44o2gxxtgy4f>
References: <20250610200528.DFD48C4CEED@smtp.kernel.org>
	<mfcsekeqtzsoqubme6rawl6hntgchjq6nr2bzwrty2rubahpja@44o2gxxtgy4f>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 16 Jun 2025 19:03:48 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> On Tue, Jun 10, 2025 at 01:05:28PM -0700, Andrew Morton wrote:
> > 
> 
> Andrew,
> 
> Can you queue this into mm-hotfixes? This fix complements the one at
> selftests-mm-add-configs-to-fix-testcase-failure.patch for systems that do not
> support uprobes. We should also have sufficient reviews, I think.

No probs, thanks.
