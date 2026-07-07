Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387E03EB0EE
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783423623; cv=none; b=eghWj9k5AakZgxCkoS/VBIjnMSwDzFLrUdSUzgU1M2D4PvvZh9xhclAOj3PlSmj6CBHdF8iUN8oXfECaYtT7Bw11mGEQZcWE2IGyeYRDfk6XMt+TJNG7C2cN+TCxUnK1BsW5n1VVYyq4WrG45bPRS0gXKl1688DCeBM5YWvcz3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783423623; c=relaxed/simple;
	bh=IplPwlKr7n4K8DcMniNIe9G5J4f4uKNkmpGOc9ZBD28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgrKZJqsgQKFDd3M+mCQMFTgj+SMPhEd+Iu/LvVYRd+CZE4W/oIP7E+0W1vl+h83SVSQ506b9Yf2eQftdjru7J+A6OVh55vJezInKrGCVWicz4YO92CVANzRtqQ2R1BF128OW2aWdeu9mHdZklxbkIRkYgSSuxVCYoEbXDQJKuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=rz2HundI; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="rz2HundI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oFQ5LA2QdTaVDs2AjDeZyiatQ+GfzL6Dm3NCqdhZGV4=; b=rz2HundIqFtPFaphkPL73VwMo7
	wpk91gGhvdvQxQW3U3WS3f/Bm+33eTacA1pnUH0I9muByxw+ZwH7VyF4ZrykEqIeR44JMVDZ9SeJT
	sA58S99VGnEkl1yiyMf0Msw42G9AKQpqXd7FTLObb6xXWFJJV+nP1TP1Rm2Ho51Xf6VqoK1FjCW7S
	9cBpsiYSCExCIPXBJCR9++Nard8Awsj46AJ7X0yFZYkRO4rxpy4Q4//tB77ZS+MKdxSHTNSBblu5E
	Vic0Z3dccFqYIudPu5M3e3aOaGOtJBVMb4Cpa68+9FrR0zyeGns2N0YQ3NFqH039lfhbznFfiozCe
	IE5IRy0w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wh3wu-0029gK-0J;
	Tue, 07 Jul 2026 11:26:48 +0000
Date: Tue, 7 Jul 2026 04:26:43 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, kent.overstreet@linux.dev, 
	bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <akzZSIN5ALd8iH52@gmail.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
 <ako1sMPVu4dfQR4K@casper.infradead.org>
 <akuFSv7JaXo6M8gx@gmail.com>
 <akuT8pEjBKvByPlA@arm.com>
 <akuzsny_3EpxaPww@gmail.com>
 <akvW9RwjVmRnNzHM@arm.com>
 <akw4FspAoT60tQeu@arm.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akw4FspAoT60tQeu@arm.com>
X-Debian-User: leitao

Hello Catalin,

First of all, thanks for th
On Tue, Jul 07, 2026 at 12:19:50AM +0100, Catalin Marinas wrote:
> On Mon, Jul 06, 2026 at 05:25:25PM +0100, Catalin Marinas wrote:
> > On Mon, Jul 06, 2026 at 07:53:30AM -0700, Breno Leitao wrote:
> > > On Mon, Jul 06, 2026 at 12:39:30PM +0100, Catalin Marinas wrote:
> > > > I wonder whether we should force the scanning to happen twice in a row
> > > > and drop the min_unref_count. Those transient leaks happen because of
> > > > some micro/milliseconds miss of a pointer. If we have new white objects
> > > > of the end of a scan, go one more round through the root and gray
> > > > objects (but do not reset them to white) and only then report the leaks.
> > > > If the white objects have been reported already or we don't have any
> > > > left, skip this additional scan or bail out early. We could have a
> > > > tunable for this one to go 2-3 times if needed, though I guess twice is
> > > > sufficient. The interface is also preserved as you do an echo scan only
> > > > once (or twice initially with the checksum calculation).
> > > 
> > > That is a good proposal, and I am happy to hack it up.
> > > 
> > > On the other side, I _think_ we want to have both approaches
> > > (your rescan-after-white) and min_unref_count. They serve different
> > > purposes. This is how I see them serving different purposes:
> > > 
> > > 1) This rescan-after-white proposal:
> > > 
> > >   Target: Developers that cat manually scanning for leaks when they
> > >   develop something.
> > > 
> > >     a) The goal is to produce a memory leaks after the scan is done.
> > >     b) Latency is more important than false positives
> > >     c) min_unref_count = 1
> > > 
> > > 2) min_unref_count 
> > > 
> > >   Target: Production servers running kmemleak on some cloud "probe
> > >   points", where the service will run for hours/days.
> > > 
> > >     a) Latency is not important (system is automatically deployed and
> > >     tested)
> > >     b) False positives is heavily undesirable. It causes an alarm to get
> > >     some engineer to investigate.
> > >     c) In this case min_unref_count will be super high (>10)
> > >       - I.e, just report when you are pretty sure this is a real issue.
> > >    
> > > Anyway, that's what I'm seeing from my angle. Let me know if I'm way
> > > off.
> > 
> > You are right. If you only ever use min_unref_count of 2, then the first
> > option might be alright but for larger numbers, you can't just keep
> > scanning 10 times in a row. If option 1 works, we might be able to get
> > rid of the transient leak annotations.
> > 
> > I got Claude to refactor for the first idea and it mostly works. For
> > some reason, after modprobe kmemleak-test, it always does the
> > confirmation scan. There's an object (vmalloc) left that's reported as
> > a potential leak candidate but not confirmed in the subsequent scan.
> > I'll check tomorrow, need to finish the day early.
> 
> I found the issue. It was the passing of the excess_ref on the
> subsequent scan. I thought I could avoid marking gray objects as white
> again in the second scan but it messes up the excess_ref since they are
> counted only after the object became gray. I had to add a flag,
> OBJECT_SUSPECT, since we mark all objects white again for the second
> pass. In principle, it's not different from your two scans approach,
> only that they are done back to back.
> 
> Anyway, a better diff for the first idea below. I need to do more
> testing and can turn it into a proper commit (if we don't deem it
> redundant because of the other min_unref_count).

Thanks for it. I've reviewed it and it looks sane.

I am also testing it on my side.


> +static bool flag_suspects(void)
> +{
> +	struct kmemleak_object *object;
> +	int suspects = 0;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(object, &object_list, object_list) {

__kmemleak_scan() above alread iterated over these objects. Is it
possible to piggy back on __kmemleak_scan() list_for_each_entry_rcu
forthe objects to flag SUSPECTS?

> +		raw_spin_lock_irq(&object->lock);
> +		if (unreferenced_object(object) &&
> +		    !(object->flags & OBJECT_REPORTED)) {
> +			object->flags |= OBJECT_SUSPECT;
> +			suspects++;
> +		} else {
> +			object->flags &= ~OBJECT_SUSPECT;
> +		}
> +		raw_spin_unlock_irq(&object->lock);
> +		if (need_resched())
> +			kmemleak_cond_resched(object);
> +	}
> +	rcu_read_unlock();
> +
> +	return suspects != 0;
> +}
> +
> +/*
> + * Scan the memory and report the unreferenced objects as leaks. Must be
> + * called with the scan_mutex held.
> + */
> +static void kmemleak_scan(void)
> +{
> +	struct kmemleak_object *object;
> +	struct xarray dedup;
> +	int new_leaks = 0;

It seems new_leaks and dedup are not used at all.


reviewing this code, I found that unreferenced_object(object)) is always
called/checked with (object->flags & OBJECT_REPORTED). Would it be ok to
move (object->flags & OBJECT_REPORTED) to inside unreferenced_object()?

Thanks for this work,
--breno
