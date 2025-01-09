Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C3B215F4C
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 10:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736418472; cv=none; b=rQiRygU8TJKAJXTmRujOJpBKDBhKT+GWqVsDjGR7ERtgPmm3fQa9cmqlEWU3EbamBvKM7PBBveZHXfsB0stf4mzKvSK7oFjlSIthnhbM7HhmBWLkAH4ImQ9837L7QT9a6rQuW9kmyOYF7ApNpsk3YbrX/3f90T42F/wdESE++qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736418472; c=relaxed/simple;
	bh=7sgJJt9yP8rrzkx11+NobWCVD7fikMCU1m/fATWcUsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IL3MgIhkvs6NRSACuy1jqlKvk/FJyD+F35SQNjrs95o0k5mrvYmW/lFaHuwWmH+toHifYkuTyu66tUuO0oD0CG5HOyFIVTSzSmH0KTsrIyy8uVvjwvOOxt0QFtuKvYru48GHtqmMixOFScRHkOJIw324GmM52L07jdlLaaVBeKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kkFMJwJP; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kkFMJwJP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736418471; x=1767954471;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7sgJJt9yP8rrzkx11+NobWCVD7fikMCU1m/fATWcUsI=;
  b=kkFMJwJPv7X0hspKRV0gfqkSkYdXqRa+JokdIRl2at3vYprYZ92oJ17R
   rLiF0Nk1ztjSlSuQu4wLaH61mvDAowo9C9elmaNP0fYqHPVvFOa46xS3s
   F5ZiI1ThnF1NqqJ92K4W43+Nw0jYa/lYtUe/657sznPdGGS6FFg5hDaET
   hu+5dcFMsHla7gyXVRK08LrajNFl6JToi3NyBs2NDF14uNwOT9et/5q7j
   j4o4L55Cs0d27Vl/qCGc2TVXDHmukFAm3QRX0MzZ0+s7Kc+9P+cMJ2ogL
   +CUYXVX9vHPSFMQeTmWIr9YaJYQIN6w6ikM9i9tLYy+R2DlH0ftqb8OcG
   A==;
X-CSE-ConnectionGUID: tjHl2AfZQgiWuDgs2Cq0ow==
X-CSE-MsgGUID: ZZ+CnowDRzGtKqzCe3puJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36559991"
X-IronPort-AV: E=Sophos;i="6.12,301,1728975600"; 
   d="scan'208";a="36559991"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 02:27:50 -0800
X-CSE-ConnectionGUID: 1HX4SinKRXe021TKHABvHw==
X-CSE-MsgGUID: dKcZcI8hQJO1StUjfPF8lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,301,1728975600"; 
   d="scan'208";a="108269282"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa004.fm.intel.com with ESMTP; 09 Jan 2025 02:27:48 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 17A3B3C3; Thu, 09 Jan 2025 12:27:46 +0200 (EET)
Date: Thu, 9 Jan 2025 12:27:46 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	hch@lst.de, hannes@cmpxchg.org, clm@meta.com, bfoster@redhat.com, 
	axboe@kernel.dk
Subject: Re: + mm-add-pg_dropbehind-folio-flag.patch added to mm-unstable
 branch
Message-ID: <q4kpgg5l5s3vprg7zc5hkmyo4a3gnzrsrcm6wnmfj6p26ypayv@6kmconrrwjhi>
References: <20250108033555.926E6C4CED0@smtp.kernel.org>
 <Z36LFTqnHM-jywV5@casper.infradead.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z36LFTqnHM-jywV5@casper.infradead.org>

On Wed, Jan 08, 2025 at 02:26:29PM +0000, Matthew Wilcox wrote:
> On Tue, Jan 07, 2025 at 07:35:55PM -0800, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: mm: add PG_dropbehind folio flag
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-add-pg_dropbehind-folio-flag.patch
> 
> I was hoping we'd get some response to Kirill's suggestion that we not
> do this.
> 
> https://lore.kernel.org/linux-mm/Z2WRJdKnTD5eSfBS@casper.infradead.org/

I can do this conversion on top of Jens patchset.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
