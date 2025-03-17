Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E266E23DE8F
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742219013; cv=none; b=iUeKZSTs8wgwZ1TNuD8yMwXw3t/F7BQhsovR1G1Q90EFMV2utvnGyzEuMyluzr71pQ+I27LeQxe+AU3GUbkOqibwihMLF57OQ/qxlZRoPAJ2A/EtqmMcx8GHd2V7+an4KsdC+G4+0FCv1J6fVucu1j/rAGsRr1GMhagQJR07B/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742219013; c=relaxed/simple;
	bh=+Kvx9mpDCcVCXWT2q1s/0K8ErSgaQPqCSmMqx+GlOEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezb0VJ/Iptuqm7V2sAqigJbUOUcUKcGHVNfrL886IhLba9aMNOYdro4F+v8DtaqB0eRYCmVsas3Z3j8YCOJ3qv13Ywx1+/yGRc4KP4YVpAhMeEbcYu7YqqvyXSGZraEYCq7aOdsTAtkBC1M7uu5AgRwV71U5LbjTTsTMnSRq03w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KHyzIeWT; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KHyzIeWT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742219012; x=1773755012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+Kvx9mpDCcVCXWT2q1s/0K8ErSgaQPqCSmMqx+GlOEM=;
  b=KHyzIeWTIKJr6bPiL6eWWbDa176TBZjJFcE6Wu4SIuT7hFGjxPF4axN9
   QnBcUMwIIx2XkcSmFx3NPh7DwALFujC3cwTXb/fdtThOrMjP/MVhqRxZn
   HbTtMzFH+priEvxmBzmF1bCi95oNlC1zGnjqrB33sTJGtNvULzf3jX+5l
   djQhQ/5sJ1tQfOV+gyCYXCD/SdwFQn+ebxQPajhF+aF5uoXGPwS3lRZ6U
   DOzOL2mlK3cGRMRXMJ8JubVJUoTiKJMqKyI7JjrK72hg3RQCnUFoELomm
   mXAQbq6iIHZuzGRUdcQu1pp6Zs6cHOLCyh2B1uDQp6PtffRPGXvzyQ2+W
   g==;
X-CSE-ConnectionGUID: eyWPHeEjQO+SG+XoGgXaAg==
X-CSE-MsgGUID: 1Exen/9KTVSLVlnYfO5n+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="43223478"
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="43223478"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 06:43:31 -0700
X-CSE-ConnectionGUID: J1zSbjaiQI6Sg1SOWjdAmA==
X-CSE-MsgGUID: QNU/Bdk/QD6ci0eoqeKfnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="121961276"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa007.fm.intel.com with ESMTP; 17 Mar 2025 06:43:27 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id D7F881E5; Mon, 17 Mar 2025 15:43:25 +0200 (EET)
Date: Mon, 17 Mar 2025 15:43:25 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	jxgao@google.com, dave.hansen@linux.intel.com, bhe@redhat.com, 
	Ashish.Kalra@amd.com, yan.y.zhao@intel.com
Subject: Re: [merged mm-nonmm-stable]
 kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
 removed from -mm tree
Message-ID: <v3xfxgodmsj3u7nr5octqhc3b4waguetvyklxadyrp33t3qwoq@v2my7op3lkoe>
References: <20250317053306.59F9CC4CEEC@smtp.kernel.org>
 <871puv93yr.fsf@email.froward.int.ebiederm.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871puv93yr.fsf@email.froward.int.ebiederm.org>

On Mon, Mar 17, 2025 at 08:33:32AM -0500, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > The quilt patch titled
> >      Subject: kexec_core: accept unaccepted kexec segments' destination addresses
> > has been removed from the -mm tree.  Its filename was
> >      kexec_core-accept-unaccepted-kexec-segments-destination-addresses.patch
> >
> > This patch was dropped because it was merged into the mm-nonmm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> 
> The patch is and was broken.
> 
> My last comments were completely ignored.

No. There were not. I've replied to your comments:

https://lore.kernel.org/all/u3qnggs7ddbbmh2sjifi7s47tw3cahdjemzkz3nt5szk2i34mo@pqs4dlkd7mhe/

> Since this was posted
> after my comments I had assumed they would be addressed.  Since this is
> not and never has been a bug fix I assumed that nothing would happen
> with this until the merge window and I had a little more time to compose
> cohesive response.
> 
> All of memory must be accepted before kexec happens because nothing is
> done to transfer the state of which pages are accepted and which pages
> are not accepted.

Please, read my reply on your concern.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
