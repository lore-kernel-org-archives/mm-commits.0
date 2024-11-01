Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68DF25757;
	Fri,  1 Nov 2024 01:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730423347; cv=none; b=UsHw/FBR2K7ZhnpONO2Hd85VWI3old/2FEgxs1RtbOLbDauwbCvkw/+3CsgpkwcgQ1NCmwyft1DCElzqx/Ggj7dBN2dEUSVwhl1zL6AGGzaXaD46DQ9h+woJ5obv1KEpVlNNmr02ox+n9POd406XbSOnFkSKLqyf8IduLWXTJss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730423347; c=relaxed/simple;
	bh=aTeyAP3XBxBdPZAQ0gzPq2I41mwbsMak69XkuIPhuyg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Y8yfy1UQSuTKiX+i6eU899Y/07MYY7z4EbVip9UZOuG5W5o1/dNLx/URpYN0ddevodvtgvNWnx4+2yGBJcwlWV+rVWTP54LYWPOZb3vNr3UUpCLfmU4UFnN+D7ky5xcrVO4eZmfmi9v0ZzeQomZchHvBVGFKFGHKu3chCyEPKbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ed6LY4gO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ed6LY4gO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA48AC4CEC3;
	Fri,  1 Nov 2024 01:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730423347;
	bh=aTeyAP3XBxBdPZAQ0gzPq2I41mwbsMak69XkuIPhuyg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ed6LY4gOqq6NUU5XqlTW6Z663e8Yv7N7CeXcMC58LhDKBssXvF93UOJkXP+utitml
	 6BwgWgz3wTOJ7Z9+vINF6yVP2OyTpwOtVIK1mHL5PrfO5YClAHD4k/zdVrolHo8QO8
	 q9T+39idZfcT2FHApkHB4fnUDR25tiIjJ1UZewW0=
Date: Thu, 31 Oct 2024 18:09:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Houghton <jthoughton@google.com>
Cc: mm-commits@vger.kernel.org, weixugc@google.com, stevensd@google.com,
 stable@vger.kernel.org, seanjc@google.com, rientjes@google.com,
 pbonzini@redhat.com, oliver.upton@linux.dev, dmatlack@google.com,
 axelrasmussen@google.com, yuzhao@google.com
Subject: Re: [merged mm-hotfixes-stable]
 mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch removed from -mm
 tree
Message-Id: <20241031180906.2f20977623d01b5d995f37a7@linux-foundation.org>
In-Reply-To: <CADrL8HXPjHDRAUmzLnSS0fqsw3Rt921EYm2KyEUqW-sPn15o5Q@mail.gmail.com>
References: <20241031031517.3AE43C4CECE@smtp.kernel.org>
	<CADrL8HXPjHDRAUmzLnSS0fqsw3Rt921EYm2KyEUqW-sPn15o5Q@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 31 Oct 2024 09:48:16 -0700 James Houghton <jthoughton@google.com> wrote:

> On Wed, Oct 30, 2024 at 8:15 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > The quilt patch titled
> >      Subject: mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify()
> > has been removed from the -mm tree.  Its filename was
> >      mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch
> >
> > This patch was dropped because it was merged into the mm-hotfixes-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Hi Andrew,
> 
> I posted a fixup for this patch here[1]. It fixes builds for some
> configs but is otherwise a no-op. Could you apply it? (Do you need
> anything from me before you can apply it?)
> 
> [1]: https://lore.kernel.org/linux-mm/20241025192106.957236-1-jthoughton@google.com/

Got it, thanks.  I moved "mm: multi-gen LRU: remove MM_LEAF_OLD and
MM_NONLEAF_TOTAL stats" and "mm: multi-gen LRU: use
{ptep,pmdp}_clear_young_notify()" back into mm-hotfixes-unstable and
added this fixup.
