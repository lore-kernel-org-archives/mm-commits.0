Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF7D2905
	for <mm-commits@vger.kernel.org>; Sat, 23 Nov 2024 20:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732395491; cv=none; b=kZsXNmv5IvcbE0yxMfSZmxiNPk3dr2HxiRqC/gk3MKxpvffJ4v5yudDf/04KxhhZ4HHGQzYshMllsweoaHEMRHzXjF8m+ZHDUKSdUZBKO/MXhIAjr21hIjjx7LWtZhZ9QzPjaxNTa51hxME/rDq6syk386yTbpb7HxOW8vD+BL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732395491; c=relaxed/simple;
	bh=iw3IfVEeqVZCmmH63tfvSWnMGKuYlLAyyaHP7mGQh0c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eCHSK9jhR7dg7S6YTsZC3Z57hkTxhiTrj6+gkSlPPBVozjgx134Ib65HEnNr/b/tN9UMeAD12VsGSZYtqtcc+gAzs2QwVBwstYzgU0cxkCfmzwJB902Ip5XKJHva5BrME8txKD8TK3aWXQ9GbwSJp33eHt4nLvUdffPx5Gk2QBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zs4ipMsd; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zs4ipMsd"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9a850270e2so533856066b.0
        for <mm-commits@vger.kernel.org>; Sat, 23 Nov 2024 12:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732395488; x=1733000288; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PJ5jhlyw8xTwjUsLyo10AKJim5MXpC7F7k9xPJC+Ckg=;
        b=Zs4ipMsd8oqlB8bQCaLcdH8UI5VGJgNlVgH6c1Kx8TYYhxvh83KEJv1Rd02hoO4uy/
         5l64KO3qFagD2U0bx3usDYvxtkiCDFPwggl0zN/RXniSd4YrMZVaOT6jQeWlSgFOjqsC
         VJO3qniHZyewaAntUoLxZJShVI/Z+WrwAQMUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732395488; x=1733000288;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PJ5jhlyw8xTwjUsLyo10AKJim5MXpC7F7k9xPJC+Ckg=;
        b=M1kpxbsoZwNop5Ylo1/P6RhxxNFsxO/3gVtX75WKThmGdL2nGyYNzOWqLDsC9KbuJ5
         eCsb0OTPvw2BmQ3xGJygf7/p7F1Tk0BGEeE8wgN6Degw7xV4ygLE6y7baGd6rJfY/M4Q
         Aijyt42WT8RqK6i0FpqD0vAlZlqJSIi+4X9kO1TeHUzkeYaNlEVqtshdMxhw5Tc6KoyT
         UVIBXp2KNA+nB6rMPcLYN2tFhBl5c/icvsbEoXhZMKOhJMXhYNFXD6bXtrJBYY3IDLUw
         MittUvUsM4X1Cygf6MkSUHkH7vRRQcAF3s9aG50VrpTMrsrIbABrJJTX2VbZyyAWXo/S
         g3Jw==
X-Forwarded-Encrypted: i=1; AJvYcCV6bv9loivH4wTOwPE3poTVkaGeVTuhuLwfdYaQNv1QY5NZt9GBD/0p0XgyCeM742sSXm0Io02PM5Ki@vger.kernel.org
X-Gm-Message-State: AOJu0YzxvvB5XUz6HD3EdBxn3IhcWV88PKZNDoZahh1I6DEQ9ssrpJm1
	o7Lx+oTCxSxvUujl5o7aBPqDjx2GF168Z0Rnyuz0iLfG5xGPTLZFAwFRzU8OBbjc+ByoK8r+7Dr
	7jj/Obg==
X-Gm-Gg: ASbGncu8pTK6d8R683CfpcM371Q43Hy2oAy2Wx/w2so41BI5L1oSqNKApcsCiaoVNMT
	ZiLOYuEdcJeGxqEVNiA/qoS4oUbQjsr20rOr+j0+CMDYf4+yZtkf6GjaS6qeBBYrlnnx6dUuZhl
	YFaD6LghuTGGDkCkt8ZdZ6xk13f96Yv7V63hpZUaeSgYEnG3+NONEbx1JORjsmta6Rokd88lylR
	o9DlD9ariHnWuqoINYkx6DCQC2xNYEZs7C0VNMvceLp1iiutXqyQZmXRoSf3Pya9FYL9wXnCN8l
	eVP0z5usdPHtciJJ5AfLdV/x
X-Google-Smtp-Source: AGHT+IHeLb8BXg5UDwqV0tyXWsbdSDPcUSa5UyShUf8HCFkN22dKG5GcJHXcuuIFYGuFglmkH5McfA==
X-Received: by 2002:a17:906:2191:b0:aa5:d1c:3dac with SMTP id a640c23a62f3a-aa50d1c4062mr601450066b.36.1732395486980;
        Sat, 23 Nov 2024 12:58:06 -0800 (PST)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b28f8casm265756766b.18.2024.11.23.12.58.05
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2024 12:58:06 -0800 (PST)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a850270e2so533851466b.0
        for <mm-commits@vger.kernel.org>; Sat, 23 Nov 2024 12:58:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUzuamZHmYXnZQzRzRpewvhUC2TB9zh7CRuKMjaZXw1tM5J3HLPZQt1rwTBPvcASHWmorlYj+SVzT68@vger.kernel.org
X-Received: by 2002:a17:907:1b27:b0:a9e:c267:78c5 with SMTP id
 a640c23a62f3a-aa509c00bc8mr816450066b.55.1732395485506; Sat, 23 Nov 2024
 12:58:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118193001.6aefcadd7426feafedf824e1@linux-foundation.org>
 <ZzwVo0ZbuG37pHdR@casper.infradead.org> <20241121214229.8fe091954f9bf0d26f54ed88@linux-foundation.org>
 <fa398c31-7135-457e-b97d-366c12685688@redhat.com> <17c5420c-a89a-411b-9ecd-2e868195f0d1@nvidia.com>
In-Reply-To: <17c5420c-a89a-411b-9ecd-2e868195f0d1@nvidia.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 23 Nov 2024 12:57:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=whCgz0Kh3dGB-razGqgzM=spcO1fcyzD3vQd8PEO-bA0g@mail.gmail.com>
Message-ID: <CAHk-=whCgz0Kh3dGB-razGqgzM=spcO1fcyzD3vQd8PEO-bA0g@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.13-rc1
To: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 23 Nov 2024 at 12:30, John Hubbard <jhubbard@nvidia.com> wrote:
>
> >
> > ... not able to come up with good names though. folio_page0(), folio_first_page(), ... :(
>
> Eh? You're doing great at coming up with good names, IMHO. Either of the
> above would work nicely!
>
> I'll put my vote in for folio_page0(), it's concise and yet crystal clear.

I think all of this is completely missing the point.

The point is that "&folio->page" can be *compared* to a page pointer,
even when "folio" itself is not a valid pointer itself.

Changing

        if (&folio->page == page)

to

        if (folio_page0(folio) == page)

doesn't actually help anything at all. It still makes confused people
who do not understand pointer comparisons "oh, but if 'folio' is
invalid, I can't do 'folio_page0(folio)'".

See the problem, and see how you are not actually _fixing_ the confusion?

The way to hopefully *fix* the confusion is to have the actual
comparison itself inside the helper. Something like a

   static __always_inline bool folio_is_page(struct folio *folio,
struct page *page)
  { return &folio->page == page; }

and maybe even add a comment about how pointer comparisons are valid
even when the pointers are NULL or entirely invalid error pointers.

If you want to be extra fancy, you'd do something like

  union page_or_folio {
        struct page *page;
        struct folio *folio;
  };

  static inline bool folio_match(union page_or_folio a,
                                 union page_or_folio b)
  {
        return a.page == b.page;
  }

which doesn't care about argument ordering, and allows any combination
of folio or page pointers (but unlike a 'void *' argument, accepts
*only* folio or page pointers). So then you can do either
"folio_match(folio, page)" or "folio_match(page, folio)" and they are
the same thing.

Of course, the above does depend on "&folio->page" being effectively a
no-op (ie the page and folio pointers really are bitwise the same, ie
the ->page entry is at offset zero).

Which they are, and which all the FOLIO_MATCH things verify, but it
might be worth clarifying.

Honestly, I feel that we should use that "union page_or_folio" in more
places to avoid duplicating some of the helper functions, when a
function really doesn't care whether it gets a page or a folio. We
have a fair number of unnecessarily duplicated functions, I feel (eg
folio_mapping_flags() vs PageMappingFlags()), and I suspect some of
the "convert to folio" work could have been simplified by having code
that just happily accepts one or the other.

It probably matters less today, though, since a lot of the folio
conversion has been done.

And yes, you can also use _Generic() to automatically handle either
case, and that's particularly useful if you actually want to do
different things for a folio vs a page. For example, you could have a
"size" function that returns PAGE_SIZE for a 'struct page *', but
folio_size() for a 'struct folio *'.

Like the union argument trick, the _Generic() thing can be used to
make conversions easier, when you have functions that simply
JustWork(tm) and DoTheRightThing(tm) regardless of the type, and you
don't necessarily have to convert everything in one go.

              Linus
