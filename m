Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C1736728C;
	Fri, 19 Jun 2026 10:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781864193; cv=none; b=M50HQPhuuS1DBav9Z/XSeSIWhJqXp55dF6OOjoYzObi3Lyeh/1vrJH5bb4gkhHL2NZWXDHbFfjHe0hId+mX6OiXJX9nbT7Ti4HCveHmEU9sFnNpCAvXXlaRAqqs2bylbr0WhRBHlwNTQcq2rZ3v+sbSm3ofbY6HIW1iiQ+ZtNSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781864193; c=relaxed/simple;
	bh=B2zO5F8Qy9l2ALXI7n7dSq/4ybbiVJCrwYy5ybT9PBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsYnOdiJ8eJvljLUKh22+nZUXQzphswSGNSETti/83W/x/tlzNt7VL7NVK2xpQL/6aw7El3YVm78J6WVlVbuy5BFgqGg2ybqaD301+aay0uImD9U4GZzDsfBS0cF4sUAcV9bQR6EjMMdiJBgTkf00//Vl+roAD4QCB/JMURpQKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yy8hsVd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yy8hsVd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866211F00A3F;
	Fri, 19 Jun 2026 10:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781864191;
	bh=gmdsJKY1lStIXq1xZA3tUakdrPrkKPkX9dSdVDzMZJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yy8hsVd6LttChXElqZTMvtwJVr4IIs3BnTEz9MTEItD0BMH+YR3jVrTqnKayPVqiS
	 LByM6C8x8neRJqsXXTWsZfppQsXuONR2kF2i/ZRFPcfRcL+xjCZTuStqmx44gIXlJc
	 ieJm/rDfy19UGz3lsaJe8Bfmi1tuWaNeGl7UfWuG0Ahq4Wkqz4SV95pftorZViJZBT
	 EcP2r486KhRqKdFav0wA8YOrmvBVxlJcR7Eey3+ZeNCCU0v8wKyAdxPdgchd1gKr7X
	 C+zUklCJKzTjIEfWUbtUf90lpNswn5NYMiXPcm2guHssR1r9m83dB+oo6Rujk79XDy
	 d4heAhmabtpuA==
Date: Fri, 19 Jun 2026 11:16:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, vladimirelitokarev@gmail.com, 
	viro@zeniv.linux.org.uk, stable@vger.kernel.org, peterx@redhat.com, oleg@redhat.com, 
	jack@suse.cz, brauner@kernel.org, rppt@kernel.org
Subject: Re: + userfaultfd-prevent-registration-of-special-vmas.patch added
 to mm-hotfixes-unstable branch
Message-ID: <ajUT53g6AIJKMVpG@lucifer>
References: <20260618183442.BBCD71F000E9@smtp.kernel.org>
 <CAHk-=wiQ_10MRYYW+aRfLP4Ah9gDrShOvLESXtz+Q32-9M9Y9w@mail.gmail.com>
 <9bbaa053-ea06-4b36-98ba-dc487a28964e@kernel.org>
 <CAHk-=wjWhvmy5xUcTMCJZats2cUJ5iGU4o5Kdt+OvRepu+MUeQ@mail.gmail.com>
 <cb30b646-31a0-4afe-aba2-3cb01f299c00@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb30b646-31a0-4afe-aba2-3cb01f299c00@kernel.org>

On Fri, Jun 19, 2026 at 09:53:43AM +0200, David Hildenbrand (Arm) wrote:
> On 6/18/26 23:42, Linus Torvalds wrote:
> > On Thu, 18 Jun 2026 at 14:07, David Hildenbrand (Arm) <david@kernel.org> wrote:
> >>
> >> Maybe we should rename and possibly split that up, like
> >>
> >>         VM_NO_MLOCK
> >>         VM_NO_VMA_MERGE

I agree broadly with the concept of having flags that define _behaviours_ rather
than nebulous traits from which behaviour is derived.

> >
> > That sounds saner, indeed.
> >
> >> And then have some generic "there are really special things mapped in here"
> >>
> >>         VM_HAS_SPECIAL_MAPPINGS

I think _ideally_ it'd be good to move away from saying 'special' and just being
as specific as we can about it.

> >
> > I think maybe we should stop using "bitmasks of VM_xyz bits" and start
> > moving to a "helper inlines for vma testing".
>
> 100%

Yes agreed.

I think there's a great deal of confusion and weird overlap between these
'special' flags, and I think sometimes people set one of them arbitrarily to
_get the behaviours_ they want.

And really people set these flags to get certain behaviour, so just have the
flag say what behaviour is wanted.

>
> >
> > That way we could make hugetlb not set DONTEXPAND at all, if we
> > instead just introduce a
> >
> >    static inline bool vma_can_merge(const struct vm_area_struct *vma)
> >    {
> >         if (vma->vm_flags & VM_SPECIAL)
> >                 return false;
> >         if (vma_is_hugetlb(vma))
> >                 return false;
> >         return true;
> >     }
>
> Yes. DONTEXPAND is a weird thing and I am afraid it's getting abused at other
> places.

I think often VM_IO too.

The vagueness of these flags is unhelpful, and the overloading of 'special' is
in mm is hideous - 'special' isn't special because there's about 3 different
definitions of it ;)

We can fix that by having explicit helpers that does VM_SPECIAL's job for it
like vma_can_merge(), vma_can_mlock(), vma_can_split(), vma_can_remap(),
vma_can_uffd() etc.

>
> >
> > Ok, so that vma_is_hugetlb() thing doesn'ty exist - but we do have a
>
> We have is_vm_hugetlb_page() that we should probably rename.

Ack will do! That's an annoying/confusing inconsistency.

>
> We probably need helpers for VMA vs. VMA flags, but I'd let Lorenzo figure that
> out. (CC)

Yeah I can take care of all of this given it forms part of my VMA flags ->
bitmap series(es) anyway.

>
> > VMA_HUGETLB_BIT to implement it. I wrote it that way mainly in an
> > effort to make it all make sense logically.
> >
> > And maybe we could get rid of VM_SPECIAL entirely at some point usign
> > these kinds of helpers - by making "vma_can_merge()" and others that
> > currently use VM_SPECIAL use the *actual* real bits explicitly and
> > simply making each rule have simple and logical tests.
>
> Yes. Or make them build on each other (vma_maps_special_pages() or whatever)

Again though I'd rather we find a way to be as explicit as we can be, the
'special' overloading is a bit horrid.

Or settle on one meaning of special that we define somewhere :)

>
> >
> > And the reason we should pass in the vma - not just vm_flags - is that
> > often things like "is the vma anonymous" is part of the decision of
> > what can be done.
>
> Right, I think the problem is that sometimes (VMA modifications) we might have
> the updated flags but not the updated VMA. But again, I'm sure Lorenzo could
> figure that out.

This is where the helper struct work comes in handy for the merge logic, as you
can have a vmg_can_merge() helper which achieves the same thing even when you
don't have the VMA yet.

>
> >
> > I think this would make the code both more flexible _and_ more
> > understandable if we had these kinds of helpers for different
> > situations rather than have VM_SPECIAL kinds of flag combinations.
> >
> > But I'm just throwing this out as an idea. Maybe there are better ways
> > to deal with this. The current code does seem rather annoying.
>
> Yes, thanks for raising that; it needs a proper rework with clear semantics.

Agreed.

Will put a series together!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo
