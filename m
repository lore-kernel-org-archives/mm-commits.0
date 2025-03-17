Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4229D79D2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190728; cv=none; b=hvaPkle4yNs+BFrW7pbMHOiGXJcuEhRhQwMOCxDsL4Fgl7t+3zhEIDyaliNp6RZbIrfzvYSLmySoUDhUlgIOYLWzQ9xc0dY2PKRYBK5Z1PL0trZRNzvKBwpLWF3CXNyl8vZ/iZi3l0fU2z665+7iuH+iyVtPN+P8Dcfrk1++huo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190728; c=relaxed/simple;
	bh=Nh1+ED2YxpBXkk49XaldJXUNVD20mmqYomvF5o5YnAs=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BIQgKe+geLudiWLMctU27aaDiJBW/RUS+NdtByj2cqsIK1IkxF52K75CLrS6CFQyq9IfBv4bF299exC1ChK3amB3rOnuolq4hZeiITYx7NgQeDIlGtZoLeUwWfDYuKTsoIgEZbw9YqXCsWzPGyQj2zR3eABKsV06RH1bpBXCgeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB4E7141835;
	Mon, 17 Mar 2025 05:51:58 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 972C02000D;
	Mon, 17 Mar 2025 05:51:54 +0000 (UTC)
Message-ID: <f150abf3659e151b29a2529b266d519465b7345d.camel@perches.com>
Subject: Re: [merged mm-nonmm-stable]
 checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch
 removed from -mm tree
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	tmgross@umich.edu, ojeda@kernel.org, lukas.bulwahn@gmail.com,
 gary@garyguo.net, 	dwaipayanray1@gmail.com, charmitro@posteo.net,
 boqun.feng@gmail.com, 	bjorn3_gh@protonmail.com, benno.lossin@proton.me,
 apw@canonical.com, 	aliceryhl@google.com, alex.gaynor@gmail.com,
 a.hindborg@kernel.org, 	kurti@invicto.ai
Date: Sun, 16 Mar 2025 22:51:53 -0700
In-Reply-To: <20250317053150.5115AC4CEEC@smtp.kernel.org>
References: <20250317053150.5115AC4CEEC@smtp.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 972C02000D
X-Rspamd-Server: rspamout07
X-Stat-Signature: uzrykxrem5w3zw56coj48hekq6zboy4x
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+WdBQDOA3WeD/xmKJZ6ycIxnJpfnyRujY=
X-HE-Tag: 1742190714-124073
X-HE-Meta: U2FsdGVkX1+I0ETWHMk46OBcMSgwOQ2L6EbUE6Y3da1a8WJ5+SbpSYss/PBZbwMqIqt4U2rXMgSyCpm3Gft65jLw9bOUBIVwHGtEjdlYlQcrDA6smuuiMzGZb9j9Ec1paMicL1p9HjNUnnLq9Z9wclziCyiHa4GBdQx2qRDIN00Lg6SkyX0eTluMsLHGE/bKE10lThVGmKEdSIlsnJKdp1M17mBH2wm9bdbQzq8HqrSKmbyiBboAMlZ5zsEJNkX3GPiQZyhJRrwDrV+blflij/qVDJASgzVZhTx132xNuPDoVMErOofqcA+GETQeqv3/BGITv7hmtdm8WM6uNlf6Uu4iDexpPd3R

On Sun, 2025-03-16 at 22:31 -0700, Andrew Morton wrote:
> The quilt patch titled
>      Subject: checkpatch: add warning for pr_* and dev_* macros without a=
 trailing newline
> has been removed from the -mm tree.  Its filename was
>      checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-ne=
wline.patch
>=20
> This patch was dropped because it was merged into the mm-nonmm-stable bra=
nch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>=20
> ------------------------------------------------------
> From: Alban Kurti <kurti@invicto.ai>
> Subject: checkpatch: add warning for pr_* and dev_* macros without a trai=
ling newline
> Date: Fri, 07 Feb 2025 18:39:06 +0000 (UTC)
>=20
> Add a new check in scripts/checkpatch.pl to detect usage of pr_(level) an=
d
> dev_(level) macros (for both C and Rust) when the string literal does not
> end with '\n'.  Missing trailing newlines can lead to incomplete log line=
s
> that do not appear properly in dmesg or in console output.  To show an
> example of this working after applying the patch we can run the script on
> the commit that likely motivated this need/issue:
>=20
>   ./scripts/checkpatch.pl --strict -g "f431c5c581fa1"

Not sure it's a 'real' need/issue as any new KERN_<LEVEL> that's
not KERN_CONT will already add a new line.

And there are many other <foo>_<level> calls that do not add
newlines to the macros or functions that could be used too.

> One false warning that will be generated due to this change is in case we
> have a patch that modifies a `pr_* call without a newline` which has a
> pr_cont with a newline following it.  In this case there will be a warnin=
g
> but because the patch does not include the following pr_cont it will warn
> there is nothing creating a newline.  I have modified the warning to be
> softer due to this known problem.

I think this patch is a merely a conversion of one defect for another
and it's quite compilcated code too.

