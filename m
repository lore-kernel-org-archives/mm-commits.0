Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5782E450EE
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 19:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742239074; cv=none; b=HXXl1TA0J5umGCOEKcmjPc6IbvjF82+IpB8aEo0xeQg96cFeQ2mTQwBjbG3a+fD4RGA48+IKEp7B+b7uVY8MC1/Me52H9XL/8ioPc1fX+jz769k2gh2pz6r/dsLGImCW3BIH+UcuCc3A0MEmCMu8dE1Elrfmm1MjbqL5SZFhY1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742239074; c=relaxed/simple;
	bh=+zJRy0jiXRhodLI+cRVSOc5p+zn9mt0NbmbeqEnwjT0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=g3TKmYCcNOz8z9eFoIYvehq5G/++AugwAxHKyagR2oF94zYN0PR8xhdBTz9T4T02Y/We4JjB9sCgHW9J/0sRNwOrmWodL2VN8JRskHVu/tvnkH25H5G5mzjcgT1XW7Zme98gAKNl6DgzWtBk+UJL9X36im/RBJLC9T2npQ/etdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rPB+WI88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rPB+WI88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B96C4CEE3;
	Mon, 17 Mar 2025 19:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742239073;
	bh=+zJRy0jiXRhodLI+cRVSOc5p+zn9mt0NbmbeqEnwjT0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rPB+WI88U3AbgcEIHUByxnwdpGE0M8mAIwN1MKKFjXXyEkQ/Ux0XK1H/zzi4eia0c
	 hnkAmgB5mDNXMlywTixa+JnTlizdFx3eH+GrS3wLTfABwZC0CEFDMSs1BxKJwaH01/
	 n3cmdWw05ftXEaFglrqIWk8Y1aw0SguR5tAkpqrA=
Date: Mon, 17 Mar 2025 12:17:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: mm-commits@vger.kernel.org, idryomov@gmail.com, axboe@kernel.dk,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [merged mm-nonmm-stable]
 libceph-convert-timeouts-to-secs_to_jiffies.patch removed from -mm tree
Message-Id: <20250317121752.f2121f5df15edaac812c3f7e@linux-foundation.org>
In-Reply-To: <843db43a-9a7d-4f90-9532-47c31e231016@linux.microsoft.com>
References: <20250317053231.84315C4CEEC@smtp.kernel.org>
	<843db43a-9a7d-4f90-9532-47c31e231016@linux.microsoft.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Mar 2025 10:35:28 -0700 Easwar Hariharan <eahariha@linux.microsoft.com> wrote:

> On 3/16/2025 10:32 PM, Andrew Morton wrote:
> > The quilt patch titled
> >      Subject: libceph: convert timeouts to secs_to_jiffies()
> > has been removed from the -mm tree.  Its filename was
> >      libceph-convert-timeouts-to-secs_to_jiffies.patch
> > 
> > This patch was dropped because it was merged into the mm-nonmm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > ------------------------------------------------------
> > From: Easwar Hariharan <eahariha@linux.microsoft.com>
> > Subject: libceph: convert timeouts to secs_to_jiffies()
> > Date: Tue, 25 Feb 2025 20:17:21 +0000
> > 
> > Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> > secs_to_jiffies().  As the value here is a multiple of 1000, use
> > secs_to_jiffies() instead of msecs_to_jiffies() to avoid the
> > multiplication
> > 
> > This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
> > the following Coccinelle rules:
> > 
> > @depends on patch@ expression E; @@
> > 
> > -msecs_to_jiffies(E * 1000)
> > +secs_to_jiffies(E)
> > 
> > @depends on patch@ expression E; @@
> > 
> > -msecs_to_jiffies(E * MSEC_PER_SEC)
> > +secs_to_jiffies(E)
> > 
> > While here, remove the no-longer necessary checks for range since there's
> > no multiplication involved.
> > 
> > Link: https://lkml.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-7-a43967e36c88@linux.microsoft.com
> > Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> > Acked-by: Ilya Dryomov <idryomov@gmail.com>
> 
> Hi Andrew,
> 
> Please drop this patch as requested here: https://lore.kernel.org/all/d5035d88-f714-47c2-ace6-8bd609d84633@linux.microsoft.com/

OK.

> Also, the scsi: lpfc patch was also queued by Martin: https://web.git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?id=a131f20804d6

OK, git will figure that out.
