Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB3033987E
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 00:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786494435; cv=none; b=UbAv0UESrJWqtjR3/hmXToIa+2n4kuoCwoUKwG4smzR/hYkVYpdjaRmBIanQBRLTKowkVfVSQAnxTDyifU/+IJxFrN6A10EDFwRfV1Wa2HoMYko5CVb4yzO6gPcsnY0XRawJrgbhLoVISgstfhvUD3S07ZqnDIoY3TxU8lfUVCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786494435; c=relaxed/simple;
	bh=ORQzhlgD4Kr4vLAagEMAMgrLC/7l4jrQ9CWSN7TwUA4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=HRKHkVZN1ksXj4XUSUpngu2OJjjnU/3xFgdGJNdyZQdBtt/t6WwvZKLCuNSicgyQXP7c5ibwIvsIjlbm24ofkohLVzmpfHdLbYnI524ZVaQU0h+p6hF7Y3Oj69U1o+8+J89dbHV+hqDXYWcA5k6a+pAU2aiJuY/WFsQT8XS+tCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ieGROTSJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ieGROTSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8DD1F00A3A;
	Wed, 12 Aug 2026 00:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786494434;
	bh=qG+lKPEemN6eouLTMYgrSIpSvsYzzW8mFU7XppiEwkQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ieGROTSJtjt4mm9KowXgzx5n2unlLwhO2+fizeq1K6SBy/bqmTDHoz9nxrpib/qKU
	 pvVcYP2DO7dLgfB2avVdw+j5Qi/AkfwLI8zzocOzc8spc+8gDdrhyJ9+ETIpP4PeY7
	 mCYWa558gMwWBAWBpe53lu4s25ClTjbWnTUVxWFw=
Date: Tue, 11 Aug 2026 17:27:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-Id: <20260811172713.d9f98913055bf8dc8331cda1@linux-foundation.org>
In-Reply-To: <anu1N-DOnQwxO1kF@skinsburskii>
References: <202608101053.PhnVUM4u-lkp@intel.com>
	<20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>
	<anu1N-DOnQwxO1kF@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Aug 2026 16:50:15 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > Caused by
> > 
> > 	121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
> > 
> > 
> > Stanislaw, you've previously said that this is a can't-happen, but boy
> > I'm getting tired of seeing this warning report.  Would the below change
> > hurt anything?  I can't immediately think of a cost-free way of doing
> > this.
> > 
> 
> I think this change doesn't do any harm.
> Perhaps it worth a WARN_ON_ONCE to expose a wrong fault handler
> behavior?

Like this?

		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
			if (hmm_vma_walk->locked)    /* needed by sparse */
				*hmm_vma_walk->locked = false;
			else
				WARN_ON_ONCE(1);    /* broken fault handler */
			return HMM_FAULT_UNLOCKED;
		}

