Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3583D27CCEB
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716904; cv=none; b=VyJa+S1u8FOv7XBHWqrpCt/Ll8iq8bFPqUS1Oq0wKz4WevNKllS+CSOtBsAgmaSYp0RzC6U6Bj8V8MaF9/TO8qvYtwiKE71gbE3A4tv97IR6cI9WkRX//UBGa8Qvd51QEeYRu6DhMIxfZ5UcBAhioyELam3sEsu5KwUD4GiC9A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716904; c=relaxed/simple;
	bh=7+OOls/kSYl81Tzf4POcz6WiqElKGQ19eYbsHb9W0bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3mbkeQjgpCGlFcUtMJ3Z3GsmiPlptSXaHIf8ivCO+USg4U3+ahgBJcwOEIfihc+v5wvtnbLnNOd1Bai+6XkVIbuD12tOrmhP6CqH+nx8KakoUyEuYnd3XP5uKZA8H4qPGOQgpyuSsuuUfSRxk37AaZuQnTOrWnaEGjOmQDkxoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e+kkJ9+q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+kkJ9+q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746716901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rnra+xaz4bilHdxqaW+0Rxi++MQKtKNjghP9zID+9/I=;
	b=e+kkJ9+qH/pPm0tL9UTIztOOiq8LqIWZZbnJM1jmBk5XQoh2ZeieyzxiB5s/QyZer4SOoU
	FdME1XPUr01Bbud6PJQh9csJkrrZOsOWKj54BshrqR5FxLwfxvm2+TsTlJ3UYke3xxdvW2
	PXc6UC4QsucfrF9UzoiBwIaKkNA3g5c=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-6VnsuVMrPiam1Zk_Lf3BAA-1; Thu, 08 May 2025 11:08:19 -0400
X-MC-Unique: 6VnsuVMrPiam1Zk_Lf3BAA-1
X-Mimecast-MFC-AGG-ID: 6VnsuVMrPiam1Zk_Lf3BAA_1746716899
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c793d573b2so205887885a.1
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 08:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746716899; x=1747321699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rnra+xaz4bilHdxqaW+0Rxi++MQKtKNjghP9zID+9/I=;
        b=pFuqZkJUywLanA9DdKFXKqNVGdIXU0aTa6Sb10gXII/zmLi7783CDXYlBgKJek29gD
         z0g1u1/kMu8f1SD4u8Qmv6t0KPjZ+Se7ek6CX9nZvK0P9BAxe+HTEI80FPDvrm/b2129
         PFS6jcypQbPtmhZqCIAwHlXvlwxgnNi7PqHKbmahdWjAzqia4w6HB3zrsx19tNVvPPew
         v2XXowqUYFtCcS8p4YG6td6OMGHZQuDfOW4zCz46qVm6MPq3fysGD8FbMN8KU7kBd9H4
         BztGjQTrEuH2JgUnZ1mYg179F4aGW0+nkoPp+j5bD1zgZeJAcwDTh3oKIMMNUg7e5jtk
         bYxg==
X-Forwarded-Encrypted: i=1; AJvYcCWL8DVdiL1ciY2LaSJyB3rBOzZj+AwCJNHqY/PGRg5AzQuMW8vtLLy88hdolkgzuVXF9PAp9rZ0oPpJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5wrxcXRfciW4f/mDvB1EdkzE69vCTw7nVlB/iHTtU1yqeOf9G
	4EXd9R+9Bg1EbfSPVU7wN5Bu9UFYXjNDjZQ6yHW/+yjXKZJgo7h9zJ5uY9abWghjvPzoRWoiSqJ
	DhU9nDl2bM0umEvtEStNITbN61/FptUdmSUQcXOyo/b/p5DRoJW480RB/UmE=
X-Gm-Gg: ASbGncvsXtusak5xHMshbCdMCabdJZeDmiAsVQ84E2HBJi68f8Ylk8W6E5utR/tzrnF
	6AGr2XC+AdMOO92XMSRiu2O8QE34eE10O3midVUz3MKO0cKydE4XXcdqHdGLHY5pVhDITpVGZsx
	JN8kJZXet8I10PPbap1J6UrZ+rF5I5SpiLgWVP4VTMBl+4Dlw8g1+AXSjkC2J+3ug1AV6MLyx6S
	S2QItV2aO9OuYVXxgYEhJDzLyzv1kaoV+J1C3XuQ5fhnYPJjxkDbxBbBj97paZN2sPDLZenknZM
	77I=
X-Received: by 2002:a05:620a:2913:b0:7cc:8716:729e with SMTP id af79cd13be357-7cd010f3f74mr2979885a.3.1746716899216;
        Thu, 08 May 2025 08:08:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHt+6x6Gk7S43XFpPHY34feRU5AlwSz181xaoqDUMYIOl9XqeX99iY9jvmFJW/QWTH4itWwnA==
X-Received: by 2002:a05:620a:2913:b0:7cc:8716:729e with SMTP id af79cd13be357-7cd010f3f74mr2973485a.3.1746716898669;
        Thu, 08 May 2025 08:08:18 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f98a89sm3293385a.53.2025.05.08.08.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 08:08:17 -0700 (PDT)
Date: Thu, 8 May 2025 11:08:14 -0400
From: Peter Xu <peterx@redhat.com>
To: Pantelis Antoniou <p.antoniou@partner.samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	wade.farnsworth@siemens.com, jhubbard@nvidia.com, jgg@ziepe.ca,
	david@redhat.com, c.briere@samsung.com, artem.k@samsung.com,
	David Howells <dhowells@redhat.com>
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aBzI3sl6r3HtAWP4@x1.local>
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
 <CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
 <aBy8v7gi3tsQ5-iy@x1.local>
 <20250508173612.34d1bea3@sarc.samsung.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250508173612.34d1bea3@sarc.samsung.com>

On Thu, May 08, 2025 at 05:36:12PM +0300, Pantelis Antoniou wrote:
> On Thu, 8 May 2025 10:16:31 -0400
> Peter Xu <peterx@redhat.com> wrote:
> 
> Hi Peter,

Hi, Pantelis,

[...]

> > > @@ -1271,8 +1287,6 @@ static int check_vma_flags(struct vm_are
> > >  	int foreign = (gup_flags & FOLL_REMOTE);
> > >  	bool vma_anon = vma_is_anonymous(vma);
> > >  
> > > -	if (vm_flags & (VM_IO | VM_PFNMAP))
> > > -		return -EFAULT;
> > 
> > Is there's any justification that this won't break some existing GUP
> > users that may rely on properly failing at pfnmaps?
> > 
> > IIUC netfs isn't the first one that wants to GUP on top of pfnmaps,
> > KVM does it for years and so far it was processed in a standalone
> > path:
> > 
> > hva_to_pfn:
> > 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
> > 		r = hva_to_pfn_remapped(vma, kfp, &pfn);
> > 
> > That started with supporting real pfnmaps (with no page struct), but
> > pfnmap with page structs can also happen afaict, and kvm processes
> > that too by checking page==NULL ultimately, e.g. in
> > kvm_release_faultin_page().
> > 
> 
> I see. The problem is that we're not the owners of the code in netfslib,
> and it is considerably more intrusive to fix things there.
> 
> This is a hotfix for a userspace regression. I sort of agree that having
> different handling for these areas in netfslib would be ideal.

Do you mean this used to work in older kernels?  Some more info on the
regression would be more than welcomed if so..  If it fixes a kernel
regression, we may want a Fixes for whatever patch at last.

Or do you mean it's a regression caused by userspace change?

Thanks,

-- 
Peter Xu

