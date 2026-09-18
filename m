Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFC83A0B24;
	Fri, 18 Sep 2026 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789744878; cv=none; b=gSf3TfvwSfjbrM1XJo21GmDtBwuaj6rMTwMfrxqaApqHUtA2Gb8OJ1g7Ada18Gn/5ufgPKl0VqlLGI0hdsipSR7KRxiSehHnaDVDEgWlgBf0G9+JLsuWg3mPdDSUSqfFR24S7FJNv6PELyigcJXUVDvyKzDb0pJCVrkvkP10llU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789744878; c=relaxed/simple;
	bh=U8ODHdSKny66wr0oMnlRGnnHFzuLndQuNF651qJLB+M=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=neAe9yJBkifLYPctY/+e1j6V2WRs3t+lNuC2pDLXbu9XzwCKa1tQInjb1qotgvPgH/l7vUfLS8lf0iOIR8VNwi9btkyjS0PIbhY58qsq+nZjaushVsAsqI1+k5+HIo7LiqX45I3DAcfjbulyIzEn8sYYb+6TRMP971/lc2YS7YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o83YBWpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o83YBWpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE77D1F000FF;
	Fri, 18 Sep 2026 15:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789744876;
	bh=q6mb4bo3066C114onmtwA2jTHgOd8LP56tEYxMezBak=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=o83YBWpKexcuh5qaw8zKN91TZja0fE6bpcSTbDALlNIfed4uM5cXoCDj4fV4edB6x
	 p2/r63HAtNvBzzAzDpBrKsZ2GUFdSBumUIjxAHlk6zt1NtnBZZSB77sZAB8XycBCcz
	 YPtZ9dBYQrwss4Tf9NNHyhC9ycIkdu+bbQhCDbi0=
Date: Fri, 18 Sep 2026 08:21:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: mm-commits@vger.kernel.org, yu-cheng.yu@intel.com, vbabka@kernel.org,
 tglx@linutronix.de, stable@vger.kernel.org, rppt@kernel.org,
 rick.p.edgecombe@intel.com, orsonpeters@gmail.com, ljs@kernel.org,
 liam@infradead.org, jannh@google.com, david@kernel.org,
 dave.hansen@linux.intel.com, yanglincheng@kylinos.cn
Subject: Re: [merged mm-hotfixes-stable]
 x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch removed from -mm tree
Message-Id: <20260918082115.5d674aa466b44098933947c3@linux-foundation.org>
In-Reply-To: <aq0hScEaD5kZ1y8C@pedro-suse.lan>
References: <20260918054346.05DFE1F00893@smtp.kernel.org>
	<aq0hScEaD5kZ1y8C@pedro-suse.lan>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Sep 2026 12:40:32 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> Hi Andrew,
> 
> On Thu, Sep 17, 2026 at 10:43:45PM -0700, Andrew Morton wrote:
> > 
> > The quilt patch titled
> >      Subject: x86/mm: fix pmd_modify() dropping the dirty bit
> > has been removed from the -mm tree.  Its filename was
> >      x86-mm-fix-pmd_modify-dropping-the-dirty-bit.patch
> > 
> > This patch was dropped because it was merged into the mm-hotfixes-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> You might want to drop this commit. It was already merged in
> 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf from the tip tree.
> 
> (Linus tree f7491d7c81db0e7c304a7bd757a76d2fbeaff80e)

Thanks.  Done.
