Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341A8318BA6
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 14:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783432897; cv=none; b=Z7+3HEWaJcewemoq7ru3jzae3o3OWTGVN6egYBBeMWBe3H9kQ5C1Q++0+W2454Kjk089cZFS2kbBPBc6QFbZJ78+xIf9F28xVGDxpxbXlCQ8gRIYuL1OZxyVzPVl9+RMloKJaSUtMrFfn/kZ31KqT0p3WRHzIyVFHLMHON5kYZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783432897; c=relaxed/simple;
	bh=JQqeB3G3YTA/aR+zakbqBAj5CiR0az6xS/9uopP7Cpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZdkkQZ7xw47BgSF3xmfNirA+lUJ5F8rQN4bgfNuQubHDcE5brdnxK4fPbur03hLqtflezx5emL7xfPWu44b9FHQI8qRxfEOl1Oy+yRKKFx82P2PIGvn7W6+jGdemSXiJUX0gLddzQXGyZRSH0hi7YFM262FMJ+jofM1ZNk1JVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=on1CrmVs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="on1CrmVs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32B031A2D;
	Tue,  7 Jul 2026 07:01:31 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 720983F85F;
	Tue,  7 Jul 2026 07:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783432895; bh=JQqeB3G3YTA/aR+zakbqBAj5CiR0az6xS/9uopP7Cpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=on1CrmVs6aqGizdagcu6fmpcXo/91CCv/thPU993H8sr58C2bvyXUP/XDqv94Z9Ur
	 Vpo+Yf9rmjSj/HnFzZR7Uo4tQw9HUVv5FPWlcD71sfEqZSWpZF4Bnwl/Vq3MVtNWgR
	 tyjK719v3+O44uvlbed7611n8OkCMc/eeoKi+xgY=
Date: Tue, 7 Jul 2026 15:01:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, kent.overstreet@linux.dev,
	bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <ak0GvJEFPE5M43f5@arm.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
 <ako1sMPVu4dfQR4K@casper.infradead.org>
 <akuFSv7JaXo6M8gx@gmail.com>
 <akuT8pEjBKvByPlA@arm.com>
 <akuzsny_3EpxaPww@gmail.com>
 <akvW9RwjVmRnNzHM@arm.com>
 <akw4FspAoT60tQeu@arm.com>
 <akzZSIN5ALd8iH52@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akzZSIN5ALd8iH52@gmail.com>

Hi Breno,

Thanks looking looking at this.

On Tue, Jul 07, 2026 at 04:26:43AM -0700, Breno Leitao wrote:
> On Tue, Jul 07, 2026 at 12:19:50AM +0100, Catalin Marinas wrote:
> > +static bool flag_suspects(void)
> > +{
> > +	struct kmemleak_object *object;
> > +	int suspects = 0;
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry_rcu(object, &object_list, object_list) {
> 
> __kmemleak_scan() above alread iterated over these objects. Is it
> possible to piggy back on __kmemleak_scan() list_for_each_entry_rcu
> for the objects to flag SUSPECTS?

That list has another scan_gray_list() afterwords. We could fold it into
the same list - flag all white objects here as suspects and clear this
flag in update_refs() if the object becomes gray. We'll probably need a
counter of suspected leaks set during this loop and decrement it during
update_refs() when an object becomes gray. Only go for a second scan if
this number is positive.

Yet another option would be for __kmemleak_scan() to return true if it
found any new candidates in this loop (new white objects that could not
be added to the gray list). It does not remove the second loop but it
makes it less likely for a system that doesn't have new leaks.

BTW, I think the flag_suspects() loop was missing an early continue if
!colour_white(), saves from taking the object look. But it still does a
list walk and I can see both loops looking pretty similar that one
wonders why they shouldn't be merged.

> > +		raw_spin_lock_irq(&object->lock);
> > +		if (unreferenced_object(object) &&
> > +		    !(object->flags & OBJECT_REPORTED)) {
> > +			object->flags |= OBJECT_SUSPECT;
> > +			suspects++;
> > +		} else {
> > +			object->flags &= ~OBJECT_SUSPECT;
> > +		}
> > +		raw_spin_unlock_irq(&object->lock);
> > +		if (need_resched())
> > +			kmemleak_cond_resched(object);
> > +	}
> > +	rcu_read_unlock();
> > +
> > +	return suspects != 0;
> > +}
> > +
> > +/*
> > + * Scan the memory and report the unreferenced objects as leaks. Must be
> > + * called with the scan_mutex held.
> > + */
> > +static void kmemleak_scan(void)
> > +{
> > +	struct kmemleak_object *object;
> > +	struct xarray dedup;
> > +	int new_leaks = 0;
> 
> It seems new_leaks and dedup are not used at all.

They are in kmemleak_scan() after the second __kmemleak_scan() call.

> reviewing this code, I found that unreferenced_object(object)) is always
> called/checked with (object->flags & OBJECT_REPORTED). Would it be ok to
> move (object->flags & OBJECT_REPORTED) to inside unreferenced_object()?

They are meant for different things. The flag is for reporting and
debugfs wants REPORTED, kmemleak_scan() checks for unreferenced and
!REPORTED,

-- 
Catalin
