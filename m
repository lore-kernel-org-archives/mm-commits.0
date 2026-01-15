Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A21B261393
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 03:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768446572; cv=none; b=DZfHOuY+vIY4Eltpf6HmOw49rMUTMAd4FknTKq32GpqsgNg6/LHmPPzyU5w74jZjI1oXf5oUNcl9kGu+Um8NJgzMPdbF28iRvPrJWVBuTLywffCqqwItaOpb35FwQfxGIbleyp8xoJVCGfPP8ACftHgBbM6qQnT5gEK8Pu+lXHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768446572; c=relaxed/simple;
	bh=AB7fU4OdTqFDlXx6mdOcOM+l9aYwBcZ9nQfRanNv2hI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=lNWG4a+lFaBZZHP2rVpjOFWZGAMltrAD6uRJyf3UusDZfIGHNpN17HIcf98Bi1RRNRrJ3hiN6qi00Dp28UpypT8Xv9Fjme99QY16MWya1jfmX3NXngn2Ui4DIYRY/P0318gOdVLApc5KoemyfRD2CygM5KvWg37W9twbmC/D13A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k6DeOaDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k6DeOaDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200BEC4CEF7;
	Thu, 15 Jan 2026 03:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768446572;
	bh=AB7fU4OdTqFDlXx6mdOcOM+l9aYwBcZ9nQfRanNv2hI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=k6DeOaDAKCiN9HFEC6kJNEd5MvZ1rFv8mY2D/ri/b8Wu6UBOgoLfnBO44akKRBcoA
	 ZWYjTnz9E/MDUODmysu2NpoeDGOP2pYYVImh3r7Qs83EbqZuzBDu3+EcIsHHUhVdVP
	 HzCqPz7ckux/PaTonMEGCTl/BEcgZ4bFGN7onW1A=
Date: Wed, 14 Jan 2026 19:09:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: <mm-commits@vger.kernel.org>, <ziy@nvidia.com>, <vbabka@suse.cz>,
 <tzimmermann@suse.de>, <surenb@google.com>, <simona@ffwll.ch>,
 <rppt@kernel.org>, <osalvador@suse.de>, <npiggin@gmail.com>,
 <mripard@kernel.org>, <mpe@ellerman.id.au>, <mhocko@suse.com>,
 <maddy@linux.ibm.com>, <maarten.lankhorst@linux.intel.com>,
 <lyude@redhat.com>, <lorenzo.stoakes@oracle.com>,
 <Liam.Howlett@oracle.com>, <leon@kernel.org>, <jgg@ziepe.ca>,
 <francois.dugast@intel.com>, <Felix.Kuehling@amd.com>, <david@kernel.org>,
 <dakr@kernel.org>, <christian.koenig@amd.com>, <chleroy@kernel.org>,
 <balbirs@nvidia.com>, <apopple@nvidia.com>, <alexander.deucher@amd.com>,
 <airlied@gmail.com>
Subject: Re: +
 mm-zone_device-reinitialize-large-zone-device-private-folios.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20260114190930.f0c3ea391bc94f21a5a91d5d@linux-foundation.org>
In-Reply-To: <aWhRlcANsVnqMx1S@lstrano-desk.jf.intel.com>
References: <20260114215029.F3356C4CEF7@smtp.kernel.org>
	<aWhRlcANsVnqMx1S@lstrano-desk.jf.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jan 2026 18:31:49 -0800 Matthew Brost <matthew.brost@intel.com> wrote:

> On Wed, Jan 14, 2026 at 01:50:29PM -0800, Andrew Morton wrote:
> > 
> 
> Any chance I can merge this one through drm?

That is appearing to be simpler ;)

Please check for potential bisection holes.

> This would make my life easier to get the subsequent patches in the
> series into the next kernel release PR.
