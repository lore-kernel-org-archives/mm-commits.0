Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6666A26F46F
	for <mm-commits@vger.kernel.org>; Mon,  8 Dec 2025 07:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765180731; cv=none; b=Tgl4Se6iApl6a8ro6GwNYOcF82BKr6YyDU1PuLmPcMSTymIKXks2Ef0yTGU4918FO1ZlsbpeBymD+rErY+k0zqSC8T8Jp0/kCL8tXeo5NQfK8ck2LRZXENIZQIw637lgYHSntYzeU/BIqEQ+yat4nAD8PODZS7TVuoW40zAgm4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765180731; c=relaxed/simple;
	bh=P1/6NKONxXTd/6oQjGQUU6TOUM+Smx6QyaIIHBvY38o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ak4EU8LYM8wFwFNqLOJcDdkl/2QJ/9rCNs0cCtid2IYKI/diRq6x6QcXDjvMsLn37IAlDJpqy9mB5GpTkRCmcyHneFjQFr/BkEpud6IdPLgC4A1iQ/JC+le7Hkj4yQLvWtxBLxO0la0keAgzB6T9fT6l5HVv9C85moueQdyjfmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SY8d9uDZ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SY8d9uDZ"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779fd615a3so3799465e9.0
        for <mm-commits@vger.kernel.org>; Sun, 07 Dec 2025 23:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765180728; x=1765785528; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ZZgm3oSeHU0QU+gl2ilJ5MHbkqFnJ8nXr5Y2ViBPGg=;
        b=SY8d9uDZZJ/EAEh54G46tTU0q+H6j7Fl3E8gQV2EewnJQzL8PbF+oz+sJlCt2Pk/uX
         PTbBcER7sJbV2eACuvFuKhSpot5vp65MbeB0lMKpI90VNhYENfB58LWucj9FkIXnwluN
         T+qUwrnaAUA/VArhpT8v2DtWL6p4qEQ83jaZjzI6SFcOeFLbenWth3L14efD5+JRupuT
         JtEreXIoAGANqOE2P2s9lCLIdo+t+PFP6/5i+8dE1Rm4jDTuqdqL7E1TSaG2gPsRgLEP
         97M4unNtz8foy2tyhLGU9LweGbDb8biY57HmECk/ZlSraK1JuD73b6+AmkVnUwMiAK1E
         biDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765180728; x=1765785528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ZZgm3oSeHU0QU+gl2ilJ5MHbkqFnJ8nXr5Y2ViBPGg=;
        b=UO7hikvyDyMH3pDUnKOl0LQlm1vxRHm5+wldjIINk/D44LnohkzySl/QAxy6i/lhyB
         pX7ZQ3Lx5ZA5xkPzMYz6cnq3bSE9LQD+nOD7LhZhst3FmW46KKc1tQvpwa4IjpP69Kqi
         ZXcuCva4OQCXnPsLkD2QxMhnEpF5rgw5lqPofm+iMawd17SStAmPyflIhSvvZ/77k9gk
         GDkM/JLqASssjUUVGbJKdq8o8x7sWYTAUBRocgz4Gje+MNeAXytBAhevvr48uJNxG42H
         SHGo06bm+bT4WAkIU0AQHLHRrrM3ByJjbwDHFyYqYMya0i2b9dqPpEIhv/OLnXbg/ZEH
         kw+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXdsQE7Sb88NfPXyQ3jns6YVnj2ZNqV6l/3g9uhGmU/lbl211MWlfKj34mEXXNkWfKvg5EIPP1fQszQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwL2RIHzJLNNk5tQL4IU0tJm6Hdi3hMieou8vA3KiD3vu/JafTz
	YKe3SctmIqsOnTqUtrb638qOPOB/YzDgsz1k4vbwZX8+u0RFbL0Aj96VUFIZk6Rc0Ec=
X-Gm-Gg: ASbGncuPD/52nCndp/+yFsUgi09ww0T05DwYIL0rxf4hmus0JMISpxxNpjjm05fdrfb
	kJSlzEfbovy8NjfUZ7zy4f/Ft18gHQTS7v9XECkTyx20UmSHNgBQLLH0LNrijR8ouJaBy2C+MKJ
	T/U95k+v44M7ZRxD1xFA8sh0KzigOmBRt331KV4wkRtWeBeATMB1gr4fBpjGzMvtlzknQ2TddK4
	VA0b24z0dEj0sr7r/FAgy5hkcmuuYP33JH9G9SYXqt2gtywMhnGIw5g9HTZxEqrzrpCRoJZtnrj
	ob1VTXs04guQsebJUS/d64Y++8gh6D3KswoMjTxKWSiRQSScLQaAB0foR9jko7q1cvaRKrrwEwu
	7d4aFdyl5mw1zR/6PWJq6C833BBzxYDJGz6+mw2KUeHbMj1/4Msh5csQx8dzefceDz5/v5a87Vj
	B0BPJemJObwg==
X-Google-Smtp-Source: AGHT+IFiE6r8sOKdpr/PzomB+sS+fM2rhbxC9kfkfyW0JiKMdyTzkMS5gaIPaG2/bO3ewHWaTbl4rA==
X-Received: by 2002:a05:600c:35d1:b0:477:aed0:f402 with SMTP id 5b1f17b1804b1-47939e882c3mr39326995e9.8.1765180727657;
        Sun, 07 Dec 2025 23:58:47 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3bad4sm11393921a12.10.2025.12.07.23.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 23:58:46 -0800 (PST)
Date: Mon, 8 Dec 2025 15:58:44 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Dmitry Antipov <dmantipov@yandex.ru>, 
	Mark Fasheh <mark@fasheh.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
Message-ID: <nrgonfemkkz2bnwfkpzycfbz3luspjm65dakyjt4e4nuawklbw@cw3jqnedbyjf>
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
 <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
 <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
 <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>

On Mon, Dec 08, 2025 at 12:01:09PM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/8 10:21, Linus Torvalds wrote:
> > On Mon, 8 Dec 2025 at 10:11, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> >>
> >> On 2025/12/7 07:40, Linus Torvalds wrote:
> >>>
> >>> See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
> >>> error") which simply makes the 'last' pointer point to the actual last
> >>> entry, rather than point to one _past_ the last entry.
> >>
> >> It looks fine to me.
> >> Sorry for the noise and thank you for pointing out my mistake.
> > 
> > Note that if my fix is correct, the mistake is most certainly not
> > yours and goes all the way back to 2009, and commit 0fe9b66c65f3
> > ("ocfs2: Add preserve to reflink").
> > 
> > But I would really love to have somebody who knows that code go
> > through it, and see if my fix actually is the right thing to do.
> > 
> 
> Go through the code logic again, maybe I'm wrong before.
> 
> Take the following flow for example:
> 
> ocfs2_reflink_xattr_in_block
>   ocfs2_create_empty_xattr_block
>     ocfs2_create_xattr_block
>       memset(xblk, 0, inode->i_sb->s_blocksize);
>   ocfs2_reflink_xattr_block
>     ocfs2_reflink_xattr_header

In ocfs2_reflink_xattr_block(), the call to memcpy(new_blk_bh->.., blk_bh->.., ...)
occurs before ocfs2_reflink_xattr_header(). Therefore, the new_xh->xh_count is
very likely not ZERO.

> 
> It seems now new_xh->xh_count is 0. That's means, it is trying to add a
> new entry and here 'last' is pointing the next free entry.
> If so, the original code seems right.
> 
> Heming, could you please verify this? I'm not familiar with this logic...
> 
> Thanks,
> Joseph

In ocfs2_reflink_xattrs(), when preserve_security is false, the function sets
'args.xattr_reflinked'. IMUC, it means that if users want to preserve security
xattr items, the args.xattr_reflinked is NULL, this then results in
ocfs2_reflink_xattr_header() not executing the cleanup jobs, (in the code area
defined by "if (args->xattr_reflinked && !args->xattr_reflinked(xe))").

Regarding the clean jobs:
- by default, it only handles three types:
  OCFS2_XATTR_INDEX_[SECURITY|POSIX_ACL_ACCESS|POSIX_ACL_DEFAULT]
- it cleans the first item and shifts forward the remaining items.

It seems Linus' patch does not handle all cases. If new_xh->xh_count is 1,
le16_add_cpu(&new_xh->xh_count, -1) makes it to 0, and it will miss the cleanup
job.

Thanks,
Heming
