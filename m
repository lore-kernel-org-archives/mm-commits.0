Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E41B217F32
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 08:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744015053; cv=none; b=bXX1+TxybkqXekBBOFbXP+RUvxEbJmyaDOg0xlo0RJyiwjXb0oO40S25WQ09Xj3ZmjPJ3dW+pZ3eHRAa8OOziKROmifweYRIUvrwa2JOFZsEr6vHHJ/mFezJhKbgdpwhMLhnqffoNS12lypvftuMMYMP8ivNvJ6wA3UakCtRYy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744015053; c=relaxed/simple;
	bh=RmWYVi7hyT0XeieOnVgFRdGbQzojv9LRDAvHElmaAKg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=UkP2j46/QOuSl2oTNcgitzTGQF1lce2oW6Lf4AFOtyarjpLV8DdGJF+4ndbkaZwunUvadpspAurxQhLs222yN0EOPpEH7Y7Hn85ObxxPHM9TZ1S8jgqx431YZ+QKYOfFRstqUJONxL8Ai3dRJMvg0uUgL8Q41IFKQWuWHB6jJ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mq+meMcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mq+meMcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04F2C4CEDD;
	Mon,  7 Apr 2025 08:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744015053;
	bh=RmWYVi7hyT0XeieOnVgFRdGbQzojv9LRDAvHElmaAKg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mq+meMcbcWewk7CXvmtR55z8q1LyVHM5MhKTOda9oyePrsO7tUqi6FTco9BzPto8t
	 e027ePZv3+gA0OtQBePvpuvEAgZ7a8+/+3S5pqBrVMhucCtaZay7LfsqHFl5X9sF2J
	 uGEYmQDfv6L4HA/tW56RfH7VMiKiNecBX1eugw/M=
Date: Mon, 7 Apr 2025 01:37:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: mm-commits@vger.kernel.org, xiaopei01@kylinos.cn, sfr@canb.auug.org.au,
 rmoar@google.com, masahiroy@kernel.org, linux@roeck-us.net,
 jeff.johnson@oss.qualcomm.com, arnd@arndb.de
Subject: Re: + kunit-slub-add-module-description.patch added to
 mm-nonmm-unstable branch
Message-Id: <20250407013732.9d4ac7ba2fd485af28c5461d@linux-foundation.org>
In-Reply-To: <35d28527-50db-43ec-81e3-97b291941961@suse.cz>
References: <20250407014823.7429FC4CEE3@smtp.kernel.org>
	<35d28527-50db-43ec-81e3-97b291941961@suse.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 7 Apr 2025 10:23:00 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 4/7/25 03:48, Andrew Morton wrote:
> > The patch titled
> >      Subject: kunit: slub: add module description
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      kunit-slub-add-module-description.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-slub-add-module-description.patch
> > 
> > This patch will later appear in the mm-nonmm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Hi,
> 
> since there's a new warning (initially even error) in rc1, could this and
> other -add-module-descriptions.patch be moved to hotfixes?

Ok, but all we have is "Modules without a description now cause a
warning".

Specifically which commit caused these warnings to start coming out?
