From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + mm-utilc-add-kstrimdup.patch added to -mm tree
Date: Mon, 3 Feb 2014 18:42:45 -0800
Message-ID: <20140203184245.33ac93bf.akpm@linux-foundation.org>
References: <52ec195e.P8S/D298ZeaBLTvn%akpm@linux-foundation.org>
	<CACVxJT-HUXmBepz-GW3T1+ANkSxt80=1-kNFyHLdk+RRjHaWQQ@mail.gmail.com>
	<alpine.DEB.2.02.1402031704430.32346@chino.kir.corp.google.com>
	<20140204012816.22878.4159@capellas-linux>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaBDCiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 21:38:07 -0500
In-Reply-To: <20140204012816.22878.4159@capellas-linux>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: David Rientjes <rientjes@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, mm-commits@vger.kernel.org, Joe Perches <joe@perches.com>

On Mon, 03 Feb 2014 17:28:16 -0800 Sebastian Capella <sebastian.capella@linaro.org> wrote:

> Quoting David Rientjes (2014-02-03 17:05:04)
> > The last we heard, I think Sebastian is looking to redo this series and 
> > this patch is no longer needed.  Sebastian?
> Hi David, Alexey,
> 
> I am in the process of reworking the patches.  I'm not sure if Andrew
> was just interested in having the kstrimdup utility function available.
> 
> Isn't it too late to impose userspace trimming of newlines for sysfs?
> It seems already fairly common and expected for the kernel to eat the
> trailing whitespace, or at least ignore it.  If we change this won't we
> be breaking userspace / tools / instructions / etc?
> 

We have quite a lot of codesites which open-code the newline trimming. 
Providing a library function to do this will result in goodness.

That being said, I don't plan to merge kstrimdup() until it has some users.
