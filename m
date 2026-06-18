Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC072F8E95
	for <mm-commits@vger.kernel.org>; Thu, 18 Jun 2026 21:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781818971; cv=none; b=Mn6GBE9ob/+i+UryCeB+PX3M8DpA6HKs/VumVgUWXZsv1QjY3aa+Q4wbxaRKi6ljbW9rbFSLEV+HTnvOFilqIYGsKV1ctlbEAto0+22I85Fjt+j3lS9k6tTQSGjgc7RZ8/k73BdjrHvogbYJzzBkAnCDvFyQVZE1FfR3TGgYp10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781818971; c=relaxed/simple;
	bh=0vL8OtmpIyLy51Fv9riLDUryAsugbB3gKKFEHjgNdjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gdekuVQ9LH3tHMvRA29u1t6wHukm93Qz5yh8Z9RKoRhI9BrPc/vuC+QXzI0wDLzwkVnWLoYLv8A5Ys/HMLopEGeNhufDYK6K+4T07TnOfCgAa01z0MpdtOxXRP76JraQL3TFi6B+Zf/n+lrB7bnZFS4XDZjM1RlCSKJFJlB3fBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFQH1Re2; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFQH1Re2"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bec450b950dso201820166b.2
        for <mm-commits@vger.kernel.org>; Thu, 18 Jun 2026 14:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781818969; x=1782423769; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5p66b7ErYnujJAGTcgTXIBPkgQepiYPJRliMjdpdxZU=;
        b=JFQH1Re2kM5bQkW8IiLqwh9Fcms8WXZcIyaidpWj4DK8QZyybHN/ZFhmCy51uWczSh
         WiY+ylVc8vq4wui87bV9o91LqwiJPVZ94y4EYuDb5YJL387bNuH1qp3h6AGFvZ7DtfTS
         ViWe5rUcm2LBtPqQjV5UN6jxAzg/CTDKpcCMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781818969; x=1782423769;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5p66b7ErYnujJAGTcgTXIBPkgQepiYPJRliMjdpdxZU=;
        b=TTJm5Ptq//z4H7+sN1Adg5JzY7oBh9/zOoiTirnl0ZXNScor97CwFI2CP8nkBwrTXb
         V8egNKWNybtW4BLX43fdRnq3xQNjE1+xjXc7ma2OqmHYJ/spsixtT2QSiVtstKbkRJ3S
         sihFnTbGU5EW6cQujX1twxEcxG8A+4ToW1dkCrF0NBk6KG1fEk7SLkyI42x8FsbKKI0z
         k7rZiPWUr3AEGoTmwIFdpgsMBfzyvEkA9gtvrxqH5WEOWIAGSQOafRyLU3OgdPp/V2bC
         TjAbxL7/qiJQyl466I54cQa+ND8Vn5KtVvshqjb+2EbR5Xn8Jov+CYTtxdMDmct6xaiY
         mMpA==
X-Forwarded-Encrypted: i=1; AFNElJ+jQpQyqeVIBVbnMIeu0PoZ5FJu11fbeIz5IbQDkL6KbfsFa7bhoHPD/xUsc+2fjK1oGDkN+UtD4Dl3@vger.kernel.org
X-Gm-Message-State: AOJu0YyO6O2YqNpZfKzl/tlp3F15CG87l4tIeKs8cw43+gq+5ii7KbXi
	8h/ripFh7lgqPS1+oRS67SLfBt7eij1XSG0kqx/A5Ooq0oPTsyEZV6mSxLPjG9ZS4v2V5MkVzak
	Kt+PMNpg=
X-Gm-Gg: AfdE7clT1mIerj1j0ubSl9FPQG06TLQmydOaCrBvS6d7eAQXgKRXUe1QyjyGTtu430J
	iA/8klr7rTjv299EQBlhn8iWib0aRFdlsfXPTvKK2PhW3DWLrkDfO37CrGmzaOiQl75idLsC328
	EBoxf1A32cMR6WwcyTCUvcEJgKtYpPXAd9rwMGxt4YdGZDzvG3M7m7T26Tt9uaaRDDCDy4RL+UA
	NyUVRjF1tG725J18YFDz4utwxeap12X5CxR6p6v+AFTu7nTernc3/m5pFfMXOioK+OjKPrYRUhM
	c6BHER7EsNTcC99CXcTPHYMmuz5lC5q/nQPbmG+V3ehSsx00zkg9iyPzvu2seuY8tEPgxhFD39/
	thfv90dbboTSgKpvR/Ml9gtmEPA+DjwV0FbkntA/AexzEZPI69xvut1q5aybboLeQECsd3mMz3V
	89dLNjlszeuGxwzyPsSjNige0zEz/YzN1V+tuIE5OguUDUcO8PA30nVlS8i6Tw
X-Received: by 2002:a17:907:c805:b0:beb:133d:d2dc with SMTP id a640c23a62f3a-c097af89ccdmr49133366b.1.1781818968522;
        Thu, 18 Jun 2026 14:42:48 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0a9a00dacesm6491366b.30.2026.06.18.14.42.47
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 14:42:48 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c07680fdd12so162235766b.3
        for <mm-commits@vger.kernel.org>; Thu, 18 Jun 2026 14:42:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9uRX7UuoP0FH0wRUADyOw25cLsa6S8pySEuMTo1AUi9yoDXAx0mwOM+34bBEhVr+CVel0aXaKK4zr5@vger.kernel.org
X-Received: by 2002:a17:907:96a6:b0:bd4:8b66:c374 with SMTP id
 a640c23a62f3a-c097af88bffmr48299266b.9.1781818967276; Thu, 18 Jun 2026
 14:42:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260618183442.BBCD71F000E9@smtp.kernel.org> <CAHk-=wiQ_10MRYYW+aRfLP4Ah9gDrShOvLESXtz+Q32-9M9Y9w@mail.gmail.com>
 <9bbaa053-ea06-4b36-98ba-dc487a28964e@kernel.org>
In-Reply-To: <9bbaa053-ea06-4b36-98ba-dc487a28964e@kernel.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Thu, 18 Jun 2026 14:42:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjWhvmy5xUcTMCJZats2cUJ5iGU4o5Kdt+OvRepu+MUeQ@mail.gmail.com>
X-Gm-Features: AVVi8CfUDD-8OyBQi60IPQ8Cw_tmpKz1_FAb_-Rqt7HFrCB8V1vZaaUbe2FX8yM
Message-ID: <CAHk-=wjWhvmy5xUcTMCJZats2cUJ5iGU4o5Kdt+OvRepu+MUeQ@mail.gmail.com>
Subject: Re: + userfaultfd-prevent-registration-of-special-vmas.patch added to
 mm-hotfixes-unstable branch
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	vladimirelitokarev@gmail.com, viro@zeniv.linux.org.uk, stable@vger.kernel.org, 
	peterx@redhat.com, oleg@redhat.com, jack@suse.cz, brauner@kernel.org, 
	rppt@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jun 2026 at 14:07, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> Maybe we should rename and possibly split that up, like
>
>         VM_NO_MLOCK
>         VM_NO_VMA_MERGE

That sounds saner, indeed.

> And then have some generic "there are really special things mapped in here"
>
>         VM_HAS_SPECIAL_MAPPINGS

I think maybe we should stop using "bitmasks of VM_xyz bits" and start
moving to a "helper inlines for vma testing".

That way we could make hugetlb not set DONTEXPAND at all, if we
instead just introduce a

   static inline bool vma_can_merge(const struct vm_area_struct *vma)
   {
        if (vma->vm_flags & VM_SPECIAL)
                return false;
        if (vma_is_hugetlb(vma))
                return false;
        return true;
    }

Ok, so that vma_is_hugetlb() thing doesn'ty exist - but we do have a
VMA_HUGETLB_BIT to implement it. I wrote it that way mainly in an
effort to make it all make sense logically.

And maybe we could get rid of VM_SPECIAL entirely at some point usign
these kinds of helpers - by making "vma_can_merge()" and others that
currently use VM_SPECIAL use the *actual* real bits explicitly and
simply making each rule have simple and logical tests.

And the reason we should pass in the vma - not just vm_flags - is that
often things like "is the vma anonymous" is part of the decision of
what can be done.

I think this would make the code both more flexible _and_ more
understandable if we had these kinds of helpers for different
situations rather than have VM_SPECIAL kinds of flag combinations.

But I'm just throwing this out as an idea. Maybe there are better ways
to deal with this. The current code does seem rather annoying.

                Linus
