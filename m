Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B9B2F0661
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 21:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755034730; cv=none; b=BdlqBMLGvnwzFu2UVFcM1ipA0Y9Js2J1v5sCFMcq9PoHs5x0KeY0UzfguLmkQq5lsnvDiXvnET2zKcf8gvqWesuqyq13+woj+eXpSk+/0zg7NpM7e4RIafOz4lfj7vYggNcwH9E3MAFBNZhdHKpnWKyRDGKG50N7rRhG+oMiL28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755034730; c=relaxed/simple;
	bh=+4nMPwDlQBketY4+JzahfwNM9w2uFiiwH9ibhL1eDaY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=BWZ5Ut9NO7rrGeKI31+Jh0BLPil8sEQjdAeCX6Alk4hZ6jPpH2xh29uNlNeDiJ78Hkq45G2abnxz/xtjr9d/Yx228E2UzJ7buInymAWhqglTI8fclCpIp/O1NGNpfh80xuDORXueTUQKZOlQLY30XXfJZUzOp5RbNeukSAWe58Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XZR+4vO8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XZR+4vO8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755034727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fCZbxCnsn1oEGQ/8OG+ukBXxODhbVRpm+Wr7w9BRxak=;
	b=XZR+4vO8grx6fN7lxpbXgYBPLfHHtIWofiRiAMvSpr9PQDW/JKiV5JFTxuBN1ZtyALnMoY
	kaZvR0Y/G+rJUrV6fsIA4j3/oOWpIM+PWc/UTefuVqNVNc81e4BFaJDuqqbPHs7cfT1gIJ
	X1nCtkcfnz9+mvm8d0N8A70sVk12fIk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-h98vVWioNQ2hjZwZqTKxWw-1; Tue,
 12 Aug 2025 17:38:44 -0400
X-MC-Unique: h98vVWioNQ2hjZwZqTKxWw-1
X-Mimecast-MFC-AGG-ID: h98vVWioNQ2hjZwZqTKxWw_1755034722
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9B44180048E;
	Tue, 12 Aug 2025 21:38:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.21])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF05818002B4;
	Tue, 12 Aug 2025 21:38:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aJuwDfwoSUP_M_0D@codewreck.org>
References: <aJuwDfwoSUP_M_0D@codewreck.org> <20250812010237.B52F8C4CEED@smtp.kernel.org> <650364.1754991487@warthog.procyon.org.uk>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
    mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
    stable@vger.kernel.org, ryan@lahfa.xyz, maximilian@mbosch.me,
    ct@flyingcircus.io, brauner@kernel.org, arnout@bzzt.net
Subject: Re: + iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch added to mm-hotfixes-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <677794.1755034711.1@warthog.procyon.org.uk>
Date: Tue, 12 Aug 2025 22:38:31 +0100
Message-ID: <677795.1755034711@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Dominique Martinet <asmadeus@codewreck.org> wrote:

> skip is modified in the first if so I don't see how the compiler could
> optimize it.

I mean that if you have:

		if (skip < fsize) {
			...
		}
  		if (skip >= fsize) {
			...
		}

then the compiler should be able to take the second check as true in the case
where the first fails.

>   26923	  1104	     0	 28027	  6d7b	a.o
>   27019	  1104	     0	 28123	  6ddb	b.o

That's a surprisingly large change.

> but honestly I'm happy to focus on readability here -- if you think two
> if are easier to read I'll be happy to send a v3

I must admit I dislike goto jumping *in* to a braced section.  It's not even
allowed in C++ and Java, IIRC.

David

