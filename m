Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABF1382281
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 08:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782377091; cv=none; b=Jc+W6oqKrydSHRIDaNvAnEffL9fsPGPfcgKpMYtoGegdAEMdHgoXjGvXb96Fy+3MMaurcDemrAIA8IhJDsO3ydUAE6UkddjXRontUtJopPYaDYbo5+O0YVYNKcLHnoq5pJR397VFtKhNY/Eq5mB5omjDRzWARe6U6BXjgeJ6Ki8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782377091; c=relaxed/simple;
	bh=d9OKgPQVB966cwzlROzhUCaRcG+I9zgXev/jFh4tUPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g1bG0sHE51crWedNMinliATYyHtTZ9ZP2mdFp1dpy/7C+2myMig0sk6+fF2RDe5SUMUiXBd0dTlC0/RvJSWtyLNtvmz1EIoexkOIuwMC+Ms+qIumvVy121eRX3cJYW27q9B4oMEAftZTZ567hn4doptlt8i5r7P39J10p5Cs6qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VaWZyNqX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VaWZyNqX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MAxpp0HWIA5rQ0y1XYFwdl6PBhiAxuzeyG/BK+Ftxy8=; b=VaWZyNqXXv2x6KFocSFX8TDtMp
	P8eDT/+NrVyz6zDZb1Gcg4GHv6+RmqiKdZNAerVn/yxYCuZflAh53Aqfv5SoKZuPgzBl87KF0wGE1
	YSPumEAIV9zyrwJzpns6bTqicaLnV0Xuu3rG6z+Duo+8RfVNv8+iuBeH5wrIjdvAHArcXCqNFvW0T
	paIz1Mne2IAzb7uslJo4qiJe76Y+x5cNfoaCVepXdcz7aLkzpWUxTnWXQ1KChn3gN78NFkbVxHemJ
	ID/Fr6tOM46acT+oO8i6kEivRJ1El4FJ8tI+hpIgtMzGSXpFF+FP+g2HE4W7v6if8HZWW9InwseKd
	oJ4uU6MA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcfhL-00000009aIp-1iAP;
	Thu, 25 Jun 2026 08:44:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4D6A1300B5F; Thu, 25 Jun 2026 10:44:35 +0200 (CEST)
Date: Thu, 25 Jun 2026 10:44:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vschneid@redhat.com,
	vincent.guittot@linaro.org, surenb@google.com,
	shakeel.butt@linux.dev, rostedt@goodmis.org, riel@surriel.com,
	mingo@redhat.com, mgorman@suse.de, kprateek.nayak@amd.com,
	juri.lelli@redhat.com, hannes@cmpxchg.org, dietmar.eggemann@arm.com,
	david@kernel.org, chengming.zhou@linux.dev, bsegall@google.com,
	usama.arif@linux.dev
Subject: Re: +
 sched-psi-skip-irqtime-accounting-when-no-new-irq-time-has-elapsed.patch
 added to mm-new branch
Message-ID: <20260625084435.GT42921@noisy.programming.kicks-ass.net>
References: <20260625032952.2FC631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625032952.2FC631F000E9@smtp.kernel.org>

On Wed, Jun 24, 2026 at 08:29:51PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: sched/psi: skip irqtime accounting when no new irq time has elapsed
> has been added to the -mm mm-new branch.  Its filename is
>      sched-psi-skip-irqtime-accounting-when-no-new-irq-time-has-elapsed.patch
> 

Andrew, seriously. 
