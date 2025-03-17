Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582FA2E3373
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 06:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742191942; cv=none; b=Y21E7mURVL7Uk/1cwLqWh9ig8BahxmdL7NEyyvJONl8rRnvnHGsJeneDS+aZJurWHgBuSqDJlijC+y6krLsB89EPSnLqf3yK5tHGFfFTZDEr9vk9HW/G3w8B0yKmfBqvPfzXvuMsF3Gs6G7lRYHh0DOc3E7JS058z7ckWc+xArs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742191942; c=relaxed/simple;
	bh=iNeE9jT7wS1PRq8UceVT9tywwaRgqPpnaTszaL9iVkE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DWE1OzG2zmeoV9/8imIqWsyK2GZkcoGYDj6xvs11D00enn/6pzwUDGynryImgopIqxe/da94VV6Vz/KSHjgM78wknF1cp1aPXvw/HNTIwTe2PCjiSQnD01lVNrPdNqs1HDuqrl1poIVPehuw9Y36HgD4g7T1zpEENXT5TSr89JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D6AF81937;
	Mon, 17 Mar 2025 06:12:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf01.hostedemail.com (Postfix) with ESMTPA id 07A146000C;
	Mon, 17 Mar 2025 06:12:07 +0000 (UTC)
Message-ID: <638fa6836e1959ba42cac78125568b242e601f73.camel@perches.com>
Subject: Re: [merged mm-nonmm-stable]
 checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch
 removed from -mm tree
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tmgross@umich.edu, ojeda@kernel.org, 
	lukas.bulwahn@gmail.com, gary@garyguo.net, dwaipayanray1@gmail.com, 
	charmitro@posteo.net, boqun.feng@gmail.com, bjorn3_gh@protonmail.com, 
	benno.lossin@proton.me, apw@canonical.com, aliceryhl@google.com, 
	alex.gaynor@gmail.com, a.hindborg@kernel.org, kurti@invicto.ai
Date: Sun, 16 Mar 2025 23:12:06 -0700
In-Reply-To: <20250316230922.9d2e6c8c36fb1934ca854ced@linux-foundation.org>
References: <20250317053150.5115AC4CEEC@smtp.kernel.org>
		<f150abf3659e151b29a2529b266d519465b7345d.camel@perches.com>
	 <20250316230922.9d2e6c8c36fb1934ca854ced@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 07A146000C
X-Stat-Signature: 67boe8nhdibfdihoixx9xi78hf3wh9yi
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19+nGIbj8UWaP+9tFrxwnCfAvR9zwuIINE=
X-HE-Tag: 1742191927-855550
X-HE-Meta: U2FsdGVkX1+OfmHS/k5sMoTbHekPmEj5mgT6CE8nwGvKMwLE1lVyz+mnH/rZjqOkJvfgduD1Xgz9a6tGCi0VnIOLqoQ048cApRaaKurw9IqPxptO8NskYClp5Ml/FlmAXTyE1cF6h5CHAFz0hhF07Ou+j1gtc0mOlIy/PD4x95dqWDcU0YKT7VFeqmZ9qyFRaELWiqnNOu9XIeI91fBiZd5+FrKWwb3qdoRcgCv9ohQ5hQ9nI0M9uWhrPBxg5WeZS3pepgrGyat6X2ldQeKeaKgdIzeDJZPuoFStMSDQPHZtrANXz4kFyYNbctTv9qxS+Ao43+vtorSN2SX5TSByjn83LgWXshlfbTBuEKcFq01sVQL3NaJ+eWqTLZk7AbAC

On Sun, 2025-03-16 at 23:09 -0700, Andrew Morton wrote:
> On Sun, 16 Mar 2025 22:51:53 -0700 Joe Perches <joe@perches.com> wrote:
>=20
> > > One false warning that will be generated due to this change is in cas=
e we
> > > have a patch that modifies a `pr_* call without a newline` which has =
a
> > > pr_cont with a newline following it.  In this case there will be a wa=
rning
> > > but because the patch does not include the following pr_cont it will =
warn
> > > there is nothing creating a newline.  I have modified the warning to =
be
> > > softer due to this known problem.
> >=20
> > I think this patch is a merely a conversion of one defect for another
> > and it's quite compilcated code too.
>=20
> Well darn, it would have been nice to receive this review during the
> review!
>=20
> Should I drop the patch?

I don't think it's particularly valuable or useful.=20

