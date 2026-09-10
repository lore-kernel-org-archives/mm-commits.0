Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3802FFF8B
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 02:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789008244; cv=none; b=s2MyXrabvvlJfhW29IkQgl6kmw+t9Y/U4pKkMaOzTwNO+ief+WpWTahUawgHebjR/hSR7nfn0xBsXLCnAI82WpBiHQwBKwrhboi3fRAqElRbVN1ZfG84wlu8zx9MB7z+NcCmzAQ/O/2vRVjw28iFGbBuS/5J3KBGWKwf0FAO+zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789008244; c=relaxed/simple;
	bh=9ReJuQ8qJf1QIBHoKfjnnzjiS2jXjXxDOLZCMHAFsIw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZttafAaGgd5aHiThj59m/D5oGBSsMPkd6xezVOQ9Wb7EfWEsAgo4/VhGKt6gXAiw3FA2haXx6fCFqu6JMlAq7yYpFHu4gZSQp1MDx2Y0HR6m5sio7G9vD2KDsJcAK8rnxn1dIqXeCnjMAdv+97EHwUsYsUTwIJO05MIInSeLI1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SgKOWYLf; arc=none smtp.client-ip=91.218.175.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SgKOWYLf"
X-Envelope-To: mm-commits@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9ReJuQ8qJf1QIBHoKfjnnzjiS2jXjXxDOLZCMHAFsIw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789008238; v=1; x=1789613038;
 b=SgKOWYLfgWgU6rBX5s3OB8spPSeZgXKRGouV/jqOMOY/RSmvXhVVOkgkzvllDPGsvAP11p+k
 ybwZVDNxko4DHaeNvvax6UkC+AU0urjhV6gNIr8pn/NEvnhohNW3TuUapJOqLWmaR4jawuXgUvf
 aEgenJDa6ufmT6bdTK+CGjqM=
X-Envelope-To: mm-commits@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id ed5823ffa1079156;
	Thu, 10 Sep 2026 02:43:58 +0000
X-Mizu-Trace-ID: ed5823ffa1079156
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 0bffe67ab8a72b3725cc31c4b525709bd3a3e223
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260909153653.9e19f1d1f61a080d5bd6d2e5@linux-foundation.org>
Date: Thu, 10 Sep 2026 10:43:41 +0800
Cc: kernel test robot <lkp@intel.com>,
 David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AA5FC896-AC1B-4112-BA14-E1F8865358BF@linux.dev>
References: <202609100517.0DrzxrW4-lkp@intel.com>
 <20260909153653.9e19f1d1f61a080d5bd6d2e5@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 10, 2026, at 06:36, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Thu, 10 Sep 2026 05:56:22 +0800 kernel test robot <lkp@intel.com> =
wrote:
>=20
>> tree/branch: =
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
>> branch HEAD: 0bffe67ab8a72b3725cc31c4b525709bd3a3e223  mm/swap, PM: =
hibernate: atomically replace hibernation pin
>>=20
>> Error/Warning (recently discovered and may have been fixed):
>>=20
>>    =
https://lore.kernel.org/oe-kbuild-all/202609100351.ALNh2KwC-lkp@intel.com
>>=20
>>    include/linux/mmzone.h:1692:10: error: call to undeclared function =
'NODE_DATA'; ISO C99 and later do not support implicit function =
declarations [-Wimplicit-function-declaration]
>>    include/linux/mmzone.h:1692:26: error: member reference type 'int' =
is not a pointer
>>    include/linux/mmzone.h:1780:35: error: conflicting types for =
'NODE_DATA'
>>=20
>> Error/Warning ids grouped by kconfigs:
>=20
> Thanks.  That's Muchun's "mm/sparse-vmemmap: switch device DAX to
> shared tail vmemmap pages" not liking CONFIG_NUMA=3Dn.
>=20
> I'll try this nasty thing for now.  Muchun, please make it less nasty!


My bad.

device_zone() uses NODE_DATA() before it is defined when CONFIG_NUMA
is disabled. This causes non-NUMA builds with CONFIG_ZONE_DEVICE=3Dy to
fail.

Move device_zone() after the definition of NODE_DATA() so it is =
available
in non-NUMA builds.

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 03ed9232f186..df42fbf3962a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1686,21 +1686,11 @@ static inline bool zone_is_zone_device(const =
struct zone *zone)
 {
        return zone_idx(zone) =3D=3D ZONE_DEVICE;
 }
-
-static inline struct zone *device_zone(int nid)
-{
-       return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
-}
 #else
 static inline bool zone_is_zone_device(const struct zone *zone)
 {
        return false;
 }
-
-static inline struct zone *device_zone(int nid)
-{
-       return NULL;
-}
 #endif

 /*
@@ -2159,11 +2149,21 @@ static inline int online_device_section(const =
struct mem_section *section)

        return section && ((section->section_mem_map & flags) =3D=3D =
flags);
 }
+
+static inline struct zone *device_zone(int nid)
+{
+       return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
+}
 #else
 static inline int online_device_section(const struct mem_section =
*section)
 {
        return 0;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+       return NULL;
+}
 #endif

 static inline int online_section_nr(unsigned long nr)

>=20
> --- =
a/include/linux/mmzone.h~mm-sparse-vmemmap-switch-device-dax-to-shared-tai=
l-vmemmap-pages-fix
> +++ a/include/linux/mmzone.h
> @@ -1687,16 +1687,20 @@ static inline bool zone_is_zone_device(c
> return zone_idx(zone) =3D=3D ZONE_DEVICE;
> }
>=20
> +#ifdef CONFIG_NUMA
> static inline struct zone *device_zone(int nid)
> {
> 	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
> }
> +#endif
> #else
> static inline bool zone_is_zone_device(const struct zone *zone)
> {
> 	return false;
> }
> +#endif
>=20
> +#if !defined(CONFIG_ZONE_DEVICE) && !defined(CONFIG_NUMA)
> static inline struct zone *device_zone(int nid)
> {
> 	return NULL;
> _
>=20

