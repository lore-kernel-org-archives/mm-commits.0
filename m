Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18C72F28
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 22:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741731731; cv=none; b=eKfGljd5nj1ZQgg1170woaPuSfKUd8HxjAiGhOgxXV0IgsTTkJWXlk+q4D/XOIBrrpNMYTnnj5qwjoAXZfQzL1PAc4+2/ZzAIEa4Ias4anD3kAIj/CcxRaQBoUho2E7f1f6rbjmL2G/86q9O02BRLt/6bt60EgAaNGu2UaqHtnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741731731; c=relaxed/simple;
	bh=1qa+UkF7n6bUw0/rWkBFbmUGKTuPkmN+V74+XDclh9Y=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=o5qMKSsXfyqDcUSMDu+ivFajqArdsb3F6vIvq+XlFJvu3qw3T6Xy333a0EwB7eXVD71vcCDxI1r1JGujkC1dHj/APlf1uB/LBg6IBzDneEm5S6GgnMbAv2JXnnR78OR7/ROiwMC9uQZ/wnK91ikJfO7bkGj/tEe+r94xJ8OmZQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oj/uPtDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oj/uPtDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CE2C4CEE9;
	Tue, 11 Mar 2025 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741731731;
	bh=1qa+UkF7n6bUw0/rWkBFbmUGKTuPkmN+V74+XDclh9Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oj/uPtDkgqphrQZAAP9ObZxz3NPG4PYKFg6M5VBxaAh0Luhc1nW798b7Gxr/fEJAQ
	 tG7JKPLEI4nCZHPS/esdBBvwNISZayZw1h9l+3fNrV4uaMEpEAkp3NPHQJ098cval8
	 OvPdgBUUtca58XsmuFQbnU+oFEmLstGnRkW3NHxE=
Date: Tue, 11 Mar 2025 15:22:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Xu <jeffxu@chromium.org>
Cc: mm-commits@vger.kernel.org, thomas.weissschuh@linutronix.de,
 svens@linux.ibm.com, lorenzo.stoakes@oracle.com, liam.howlett@oracle.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, agordeev@linux.ibm.com,
 hca@linux.ibm.com
Subject: Re: + mseal-sysmap-generic-vdso-vvar-mapping.patch added to
 mm-unstable branch
Message-Id: <20250311152210.5b37a59a7f70e884877d07eb@linux-foundation.org>
In-Reply-To: <CABi2SkU2YnTV7caq+JqsO1baC0dbHm8ZibBPRfg+_WebmbC2Zg@mail.gmail.com>
References: <20250311174209.D1BC2C4CEF0@smtp.kernel.org>
	<CABi2SkU2YnTV7caq+JqsO1baC0dbHm8ZibBPRfg+_WebmbC2Zg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 11 Mar 2025 15:11:22 -0700 Jeff Xu <jeffxu@chromium.org> wrote:

> > --- a/lib/vdso/datastore.c~mseal-sysmap-generic-vdso-vvar-mapping
> > +++ a/lib/vdso/datastore.c
> > @@ -99,7 +99,8 @@ const struct vm_special_mapping vdso_vva
> >  struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *mm, unsigned long addr)
> >  {
> >         return _install_special_mapping(mm, addr, VDSO_NR_PAGES * PAGE_SIZE,
> > -                                       VM_READ | VM_MAYREAD | VM_IO | VM_DONTDUMP | VM_PFNMAP,
> > +                                       VM_READ | VM_MAYREAD | VM_IO | VM_DONTDUMP |
> > +                                       VM_PFNMAP | VM_SEALED_SYSMAP,
> >                                         &vdso_vvar_mapping);
> >  }
> >
> > _
> >
> > Patches currently in -mm which might be from hca@linux.ibm.com are
> >
> It is better to insert this patch before the architect specific change,
> and right after
> selftests: x86: test_mremap_vdso: skip if vdso is sealed
> 
> So the newly added selftest (selftest: test system mappings are
> sealed) would pass in bisect.

That's what I did.  I think:

mseal-sysmap-kernel-config-and-header-change.patch
selftests-x86-test_mremap_vdso-skip-if-vdso-is-msealed.patch
mseal-sysmap-enable-x86-64.patch
mseal-sysmap-enable-arm64.patch
mseal-sysmap-uprobe-mapping.patch
mseal-sysmap-update-msealrst.patch
selftest-test-system-mappings-are-sealed.patch
mseal-sysmap-generic-vdso-vvar-mapping.patch
mseal-sysmap-enable-s390.patch

