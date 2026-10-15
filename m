Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C8A48C405
	for <mm-commits@vger.kernel.org>; Thu, 15 Oct 2026 12:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792066302; cv=none; b=OE2qJeOAsn6J8M8lSAhOGUq7OzeZTkh6iI6M/W/Efm12OWhzuCI7+H7n0MiwkeWjyDgDQYFtUwTNgi0sivX5G9ywtqXG2Bi1QyGjz0aGdff/nml1UAqsc9Zpw0v8xg+6vdfQrReqN9g6i7/lkL+K4+LDfiiohNfQQfpmvr8fHJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792066302; c=relaxed/simple;
	bh=s+dpwrzljwGLakk7lzW2IzP/oNe9FfP6mgBY/wAaE8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nMpGhBrpMgA/WgnGzTZGPnnOX7PRh8TPsabUpLJAGdJeO6PBS8KUD9GiDLPwMnQal6iiAS6CEa5mbE0+uuIB3rZGmD5rlMSBnSTz6OIo0gmtKbwQqOjYKWBpc3Gu1STD8nlaO/giSihwwb/bkxoKAI1hIyjsYqigPQ7ZO3uQ5Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=BFLEieDm; arc=none smtp.client-ip=212.42.244.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="BFLEieDm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1792066288; bh=s+dpwrzljwGLakk7lzW2IzP/oNe9FfP6mgBY/wAaE8s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BFLEieDm8SEaVJ1/Z/qaEpeI+/9OJ8r9VDOmoPxaLVI/VweH/+Vfv90Tw/hqDllgo
	 8vMItBTo5JME8jqhMDDKf0Tar1tD8XfI+qYb8eVmURnx1W0PMHKE3NOvITPcXd4ruv
	 o12xeFxOiaKM+buvpO0SUuLNLkZTsQQanohCwFu9xzNJ23VTeRKaeYaItCRCn8AiLc
	 1mdcqqUutSB+WR25YFqT6WDU0wK4pb5DUKDdSzadw872W0+NnFLfkG0yThQfMTNoag
	 g5hW8UVV80T2RGe91GlPpZBRpPYXRIdKax0H8X29cbpzadZnLi7yRggwZUULPw+AsN
	 pR64kAiu4XKtQ==
Received: from [212.42.244.78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6ad0c2f0-0462-7f0000032729-7f00000181e6-1
	for <multiple-recipients>; Thu, 15 Oct 2026 14:11:28 +0200
Received: from mail-auth.fritz.com (unknown [212.42.244.78])
	by mail.avm.de (Postfix) with ESMTPS;
	Thu, 15 Oct 2026 14:11:28 +0200 (CEST)
Date: Thu, 15 Oct 2026 14:11:28 +0200
From: Nicolas Schier <n.schier@fritz.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	thunder.leizhen@huawei.com, thomas.weissschuh@linutronix.de,
	rostedt@goodmis.org, pmladek@suse.com, olsajiri@gmail.com,
	nathan@kernel.org, mcgrof@kernel.org, masahiroy@kernel.org,
	ljs@kernel.org, kees@kernel.org, geert@linux-m68k.org,
	denis.benato@linux.dev, chewi@gentoo.org,
	andrey.grodzovsky@crowdstrike.com, abelvesa@kernel.org,
	jim.cromie@gmail.com
Subject: Re: +
 kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
 added to mm-nonmm-unstable branch
Message-ID: <20261015-curious-spiritual-buzzard-cd9aa8@l-nschier-aarch64>
References: <20261011002340.E44771F000FF@smtp.kernel.org>
 <20261011154401.479c51b6@pumpkin>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261011154401.479c51b6@pumpkin>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1792066288-F2FFB94E-552E2E2B/0/0
X-purgate-type: clean
X-purgate-size: 933
X-Notice: Whitelisted
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-01  mail-id: 7FC42A0288  external: no

On Sun, Oct 11, 2026 at 03:44:01PM +0100, David Laight wrote:
> On Sat, 10 Oct 2026 17:23:40 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > The patch titled
> >      Subject: kallsyms: copy constants from __KERNEL__ to user, drop the inclusion
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      kallsyms-increase-marker-density-to-16-1-to-accelerate-lookups-fix.patch
> 
> There is a problem with the way this change in implemented.
> Basically the kernel Makefile (etc) only builds scripts/kallsyms if it doesn't exist.

Why do you think so?  Kbuild generates 
$(objtree)/scripts/.kallsyms.o.cmd that should list all included header 
files and other sources.  If any of them is touched, a rebuild will 
happen next time the kernel build wants kallsyms binary.  It seems to 
work exactly that way on my machine.  Or have I overlooked something 
here?

-- 
Nicolas
