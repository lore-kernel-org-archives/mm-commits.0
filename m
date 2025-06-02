Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6149022A4DB;
	Mon,  2 Jun 2025 15:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876743; cv=none; b=dJuOyLm8QXMByvMSGJN5K0v85WHdozk6piWnqgW6fS1qOpsaqozgWOW/8PBlIW+K43tdpf0/SOPtNhS5BmuvzaPg/PIqJLMYQ4jnpOukiUDKK7AHQujJ/5OqFLclHkqRnvclfz8ASv528739Y3SXMLkr3bu3XLteXPDb+pxL2ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876743; c=relaxed/simple;
	bh=ZmC+Sud3u/4GHeykvaLERKYcQYVLj/E9NZNJHm325f8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lggyWxMzM0M98VS7Lx1pa8nGx08pzL6o0O5Woadul07dZ5NQ1beehbKSkCx+a7K9DOJdKaa8XtnDDa91/VtDM6YIEpkC3LHBHELrU+Gau9FYknmx51y0syWnmesOvnE8OYvEwsNJkaZ/P1E0P4H232PzxltyFtpLrH9xfCNi1Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=evzoAVZG; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="evzoAVZG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bZKQ3RvlQT12B4UBotgSomkAWBIZV+/6M9w1WoVTUVE=; b=evzoAVZG1iG8d7Irc+Agck/zyJ
	5KcrtdreLsfo8lHepSc1O8Mqfw48gFGTz7TyR9TKLpqeq+0tAMfDa98jMFEwlJyrnQP9DHPEVOcKJ
	Ujn1baiWUtewh5VRvBW/MZJ1WI/tFCuZ85v9uL7cPNc6ZkLHkzqU+CIl93tzckADaNojQxW7M71yd
	haYt6qdpps1h/c1cwamQ5Tm6t4bIXrf26GAND6Ey8XqbaR/v1zu91nmETnD0WSmZ28CnfLakG3zZ/
	aqfkjwIxppqAFiTZ0olIQGfy9RNm7sS39DGToFPCaVinUnkhO6PhoOg2YniO7giKPKOn1C/q9oppa
	UKhMhzmA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uM6jK-000000012AS-3fDy;
	Mon, 02 Jun 2025 15:05:39 +0000
Date: Mon, 2 Jun 2025 16:05:38 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
Message-ID: <aD29wnb5zR-afWpM@casper.infradead.org>
References: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>

On Sun, Jun 01, 2025 at 03:12:22PM -0700, Andrew Morton wrote:
> Linus, please merge this second batch of MM updates for the 6.16-rcX cycle.

A word of warning for Linus since he wouldn't've been cc'd on the
earlier email.  This branch is based on v6.15-rc6 but contains a
commit which depends on 97dfbbd135cb which was merged during the
current merge window.  You might want to do a rebase or ask Andrew to
do it in order to prevent a bisection hazard.

0day-ci found the problem here:
https://lore.kernel.org/linux-mm/202506022027.IYQzZghL-lkp@intel.com/
