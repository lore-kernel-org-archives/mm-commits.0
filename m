Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A47D528
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 00:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742258510; cv=none; b=LEoWkZQ4FZPWVq8ncYUiZDuwdlQjiwNMUnYq+1f08pY5ugdrb5OEm2+yPy8ri4f1KSf/GJ//aJbUrrJeL1xuGYtHj1evqjnhLwR9TZ4BgvA3/qBYLtOVfKOUdkD5hl3r6A+dJZYbo3yDceC7+m9nbOfbpntPCtVh6sezGT7q17U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742258510; c=relaxed/simple;
	bh=rcjYatnI9MPYUaedQpPJM5mpJD4oXFFrEmp7Eh1bVNA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NWKir6WdNHaekzmp4maIiTGq5oAC93oozYZ+PR8PQFKnxoNQFNXj9hP2dIn4wior2de+9j9swdpj+oSs2cvI2yINNbRp2PV3bFAd5cOg9CyS93KK9xSTMcTpDYt8pNumu8kumdhK62xVANGI+Nz4Tg4az7XtTE9IrsIKK7CMqJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84FB21605F0;
	Tue, 18 Mar 2025 00:41:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf14.hostedemail.com (Postfix) with ESMTPA id E91693B;
	Tue, 18 Mar 2025 00:41:41 +0000 (UTC)
Message-ID: <518368d091641257ec9c27136c6d81d181d13110.camel@perches.com>
Subject: Re: [merged mm-nonmm-stable]
 checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch
 removed from -mm tree
From: Joe Perches <joe@perches.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	tmgross@umich.edu, ojeda@kernel.org, lukas.bulwahn@gmail.com,
 gary@garyguo.net, 	dwaipayanray1@gmail.com, charmitro@posteo.net,
 boqun.feng@gmail.com, 	bjorn3_gh@protonmail.com, benno.lossin@proton.me,
 apw@canonical.com, 	aliceryhl@google.com, alex.gaynor@gmail.com,
 a.hindborg@kernel.org, 	kurti@invicto.ai
Date: Mon, 17 Mar 2025 17:41:40 -0700
In-Reply-To: <CANiq72nntazBBa-MKvZcGx8udCidjurp1GVpakyDsx1caYcJ6A@mail.gmail.com>
References: <20250317053150.5115AC4CEEC@smtp.kernel.org>
		 <f150abf3659e151b29a2529b266d519465b7345d.camel@perches.com>
	 <CANiq72nntazBBa-MKvZcGx8udCidjurp1GVpakyDsx1caYcJ6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: E91693B
X-Stat-Signature: q61wgjtpf9e6ghkyk1wz7rtqrbtq64f6
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19X5Zq/jgUkVvHW7cyZzmqb6wmeZOyXhb4=
X-HE-Tag: 1742258501-196790
X-HE-Meta: U2FsdGVkX1+NPOgvKTzO5Tpwd+pKxfGL0+zGkfmrR5wxx3sABBZzIFq8g22IG9+BSUzyvr9Kacgj0mi3CtiEJMUbgfzPGkNZZWO4DU0Pmprr9nGL+r7tLHVi9x7/jieRxlM1igAwORclKfFQCyoyz2vOq42PUYBcLAxxsMgkVsKjPiZ84OumcfAP+S41+9BIWLEad5QwYE6Ocubaj85z98hgmTD6RvdR8CLUhgAgpXkjoMj+ZGsb3jH00+3BR4+D8W0Y7bsgQYcWj4VyoT/VVyRFUjft93aiB9BnAs8fwEsryrTVY4POmABayebiw2ixOsokCMhfKBelmGkymogqUBD9D2mKXAlTTw56QJOYcHsKBYEJu7g4NITMxL3Dnddw

On Mon, 2025-03-17 at 20:50 +0100, Miguel Ojeda wrote:
> On Mon, Mar 17, 2025 at 6:52=E2=80=AFAM Joe Perches <joe@perches.com> wro=
te:
> >=20
> > Not sure it's a 'real' need/issue as any new KERN_<LEVEL> that's
> > not KERN_CONT will already add a new line.
>=20
> But it is still intended that one uses an explicit newline, no?

That's my preference, yes.

> I am
> not sure I follow your other comment, so I may be missing something
> though.

My understanding is that
	printk(KERN_INFO "foo");	// or pr_info("foo");
//with some long time before
	printk(KERN_INFO "bar");	// or pr_info("bar");

will defer emitting "foo" and will append a newline to "foo"
when emitted only after the printk for "bar" is performed.

So it's generally useful to always use a newline for
complete messages as those are never deferred until
another printk is done.

> Regarding complexity, agreed, it is fairly involved -- I think the
> continuation case could be ignored, since it is rare and it is just a
> warning anyway.

My belief as well.

There are a number of macros and functions that are printk equivalents
that append newlines automatically and as well some pr_fmt uses
that include newlines too so it's almost impossible to get checkpatch
to work correctly anyway.

Things like:

fs/bcachefs/bcachefs.h:#define pr_fmt(fmt) "bcachefs: %s() " fmt "\n", __fu=
nc__
