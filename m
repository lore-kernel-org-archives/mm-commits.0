Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD85156F5D
	for <mm-commits@vger.kernel.org>; Fri,  7 Mar 2025 13:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741354467; cv=none; b=FMMX+PPi+/A/dt5AYBQos6QXFV0kkymHLVXKsy0qkJdPAeVEp9P3tG/kbI/kLXpE6cMfiJfxOTO27BMtFdRHjLlYr9v2QEvDAe5SKkuUL/SXFpU+HxC7JlCGoL5zenV4sH7rfBfOh9FyCOy/2gvhUZcASzqtfATH8Xg5g6PWhD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741354467; c=relaxed/simple;
	bh=vHHds8U7iJaVsvTbuPwiHH5QL4rmCMvaFlCr/odbyeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AHAZWVba8jTGPd0XtR1Ok1IHsC7TE5c3OfUjgf6mNCpXxlekNJnqKghlelx6DZxuUTzhpvLNUTSuMfIUrqQ8y+wIL8uoWhJeA04iq1+Or6MPaQaldlYLVxmZLviNCAJ4RpO7UFBDxVEz0rmQahTC0QrGpMDe5ygrrjcVVlZb0ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W5enEH2g; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W5enEH2g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741354466; x=1772890466;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vHHds8U7iJaVsvTbuPwiHH5QL4rmCMvaFlCr/odbyeA=;
  b=W5enEH2gsLHX2Zn57jjMF022ngXvs2TBe2ZojGdCJgCLfUl88/eygvPd
   ap/GzmLTOtXC4FYtHu4XtVM54G9G4wQib4QcCrcZzAGnB2wTGW3P+sTK5
   ONXVCpdbTs3RFLpRholl8ctmM0zNb1EgzPwusvHOnpob4CnYESX7TFsSV
   T/g36x3GUdn+E+ecg5ohUiRMThjYLd6mt1NdQ2VZgkmrwseyyNzzR6xJh
   N3ql04kH+GGPw6B2+aSNiWeOnwy+Ul50AzRwLL5R/ATsZplrqt76f/YQ2
   LqlVppUknzyBK7ECDt8FgpGXVUz8FGmJb0l++++KwEzzvPQCf+t5DyfHp
   w==;
X-CSE-ConnectionGUID: T2/8MoTASjCu0OLSVu5TYA==
X-CSE-MsgGUID: IwC2E9mJSSiaEOKQFwDUgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="64842651"
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="64842651"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 05:34:26 -0800
X-CSE-ConnectionGUID: mPbo8xF1Q3+4cNtCDwjrWg==
X-CSE-MsgGUID: gtJxrvhQQL27VK/w19+huA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,229,1736841600"; 
   d="scan'208";a="119826610"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa010.fm.intel.com with ESMTP; 07 Mar 2025 05:34:23 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 7D07B33D; Fri, 07 Mar 2025 15:34:21 +0200 (EET)
Date: Fri, 7 Mar 2025 15:34:21 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, 
	Ard Biesheuvel <ardb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	rick.p.edgecombe@intel.com, jxgao@google.com, dave.hansen@intel.com, bhe@redhat.com, 
	Ashish.Kalra@amd.com, yan.y.zhao@intel.com
Subject: Re: +
 kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
 added to mm-nonmm-unstable branch
Message-ID: <u3qnggs7ddbbmh2sjifi7s47tw3cahdjemzkz3nt5szk2i34mo@pqs4dlkd7mhe>
References: <20250304235450.87356C4CEEA@smtp.kernel.org>
 <8734fprnnl.fsf@email.froward.int.ebiederm.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734fprnnl.fsf@email.froward.int.ebiederm.org>

On Fri, Mar 07, 2025 at 07:11:26AM -0600, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > The patch titled
> >      Subject: kexec_core: accept unaccepted kexec segments' destination addresses
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
> >
> > This patch will later appear in the mm-nonmm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> 
> My apologies for replying like this, but I can not quickly find this
> patch elsewhere.
> 
> This actually can not work reliably.  The problem is that all of the
> state of what has been lazily "accepted" and what has not will be lost.
> 
> If anything is going to happen in the case of kexec what needs to happen
> is kexec_load needs to force the system out of lazy mode and all memory
> needs to be accepted before kexec load runs.
> 
> The target kernel has no way of knowing what has been accepted and
> not-accepted.  I don't think you can have a reasonable expectation
> that the target kernel knows about accepted memory.

That's false.

We do pass acceptance state between kernels on kexec using EFI
config table. See LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID.

The next kernel will pick up where the previous one left off.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
