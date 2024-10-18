Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85A0152E12
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 23:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729292564; cv=none; b=gkXYuFI80hUzXDjSSd/r1/QF4OAOapEbpCQvLevDVw5QaZ50uxOs4Rz0L+D12uI5xvIIZyz8AiDMXp4PqdLV9eBIScRDKKRVKqkkunEfRrOcy7JNY4jrGuJctb+9mZYsIZ4wG+hHBzLbxSYZT00wcB1+vHQ/POZ60EIkAjn8nwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729292564; c=relaxed/simple;
	bh=3TJkCHwUxrNimgrSc/kW9sHeDk51g4fNHlVcH5VfgEk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=dRQv6/+cRHWlANWKk4tTcQhT3km8VcLIWy2erK9pJF1tzyMiMRx2bsGtWwW28/S4Fw1ug2HrF9g4GgREcnkKnWlhy9+faHaAaVH/raj2AGDyknswl+xPLTqQdpwbIeuTeRNmuVCz9bP8dlkZa4a6lMEwODps8ASZuLKzYjDpELI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O3RipT7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O3RipT7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9A1C4CEC3;
	Fri, 18 Oct 2024 23:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729292564;
	bh=3TJkCHwUxrNimgrSc/kW9sHeDk51g4fNHlVcH5VfgEk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O3RipT7hgbmPO7M5LpmT7CDCUbS/35CrCdXvwg6ZexVEHR6Or6HmCpONqwefLNQpd
	 Xq7CUji0OPpaKoF0RqxqPvPIDCIUx+kh4GMcXdBzV9fKz8XirHap/JRdzFRwOUsPYK
	 26ONE6XgBrmh245s2LnrTgw/kYlRYuomWUdnwdOI=
Date: Fri, 18 Oct 2024 16:02:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: <mm-commits@vger.kernel.org>, <willy@infradead.org>,
 <vivek.kasireddy@intel.com>, <syoshida@redhat.com>, <peterx@redhat.com>,
 <pasha.tatashin@soleen.com>, <osalvador@suse.de>, <minchan@kernel.org>,
 <mike.kravetz@oracle.com>, <kraxel@redhat.com>, <junxiao.chang@intel.com>,
 <jgg@nvidia.com>, <hughd@google.com>, <hch@lst.de>, <hch@infradead.org>,
 <dongwon.kim@intel.com>, <david@redhat.com>, <daniel.vetter@ffwll.ch>,
 <arnd@arndb.de>, <apopple@nvidia.com>, <airlied@redhat.com>
Subject: Re: +
 mm-gup-stop-leaking-pinned-pages-in-low-memory-conditions-v3.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20241018160243.009bd38d3ab96bb05a751096@linux-foundation.org>
In-Reply-To: <2d622109-11e5-4c5d-8f13-40e695dd2127@nvidia.com>
References: <20241018224747.DBC0BC4CEC3@smtp.kernel.org>
	<2d622109-11e5-4c5d-8f13-40e695dd2127@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Oct 2024 15:58:22 -0700 John Hubbard <jhubbard@nvidia.com> wrote:

> The above is the mini-cover letter, rather than the v3 commit description,
> is that normal for this phase of the patch flow?

Often.  I pasted the revised changelog into the to-be-squashed-into patch's.
