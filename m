From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 21 Apr 2014 11:10:29 -0700
Message-ID: <53555f15.DZeNSxge1/d89Zp0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaDUSKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 14:10:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 11:10:29 -0700


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem_context.c        |    4 
 drivers/staging/rtl8723au/core/rtw_ieee80211.c |  370 ---------------
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c  |   13 
 drivers/staging/rtl8723au/core/rtw_wlan_util.c |   29 -
 fs/ext4/extents.c                              |   24 
 5 files changed, 440 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem_context.c~linux-next-git-rejects drivers/gpu/drm/i915/i915_gem_context.c
--- a/drivers/gpu/drm/i915/i915_gem_context.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_gem_context.c
@@ -240,9 +240,6 @@ __create_hw_context(struct drm_device *d
 			goto err_out;
 		}
 
-<<<<<<< HEAD
-		if (INTEL_INFO(dev)->gen >= 7) {
-=======
 		/*
 		 * Try to make the context utilize L3 as well as LLC.
 		 *
@@ -252,7 +249,6 @@ __create_hw_context(struct drm_device *d
 		 * negative performance impact.
 		 */
 		if (INTEL_INFO(dev)->gen >= 7 && !IS_VALLEYVIEW(dev)) {
->>>>>>> linux-next/akpm-base
 			ret = i915_gem_object_set_cache_level(ctx->obj,
 							      I915_CACHE_L3_LLC);
 			/* Failure shouldn't ever happen this early */
diff -puN drivers/staging/rtl8723au/core/rtw_ieee80211.c~linux-next-git-rejects drivers/staging/rtl8723au/core/rtw_ieee80211.c
--- a/drivers/staging/rtl8723au/core/rtw_ieee80211.c~linux-next-git-rejects
+++ a/drivers/staging/rtl8723au/core/rtw_ieee80211.c
@@ -930,376 +930,6 @@ void rtw_macaddr_cfg23a(u8 *mac_addr)
 		  MAC_ARG(mac_addr));
 }
 
-<<<<<<< HEAD
-void dump_ies23a(u8 *buf, u32 buf_len) {
-	u8* pos = (u8*)buf;
-	u8 id, len;
-
-	while (pos-buf <= buf_len) {
-		id = *pos;
-		len = *(pos + 1);
-
-		DBG_8723A("%s ID:%u, LEN:%u\n", __func__, id, len);
-#ifdef CONFIG_8723AU_P2P
-		dump_p2p_ie23a(pos, len);
-#endif
-		dump_wps_ie23a(pos, len);
-
-		pos += (2 + len);
-	}
-}
-
-void dump_wps_ie23a(u8 *ie, u32 ie_len) {
-	u8* pos = (u8*)ie;
-	u16 id;
-	u16 len;
-
-	u8 *wps_ie;
-	uint wps_ielen;
-
-	wps_ie = rtw_get_wps_ie23a(ie, ie_len, NULL, &wps_ielen);
-	if (wps_ie != ie || wps_ielen == 0)
-		return;
-
-	pos+= 6;
-	while (pos-ie < ie_len) {
-		id = get_unaligned_be16(pos);
-		len = get_unaligned_be16(pos + 2);
-
-		DBG_8723A("%s ID:0x%04x, LEN:%u\n", __func__, id, len);
-
-		pos += (4 + len);
-	}
-}
-
-#ifdef CONFIG_8723AU_P2P
-void dump_p2p_ie23a(u8 *ie, u32 ie_len) {
-	u8* pos = (u8*)ie;
-	u8 id;
-	u16 len;
-
-	u8 *p2p_ie;
-	uint p2p_ielen;
-
-	p2p_ie = rtw_get_p2p_ie23a(ie, ie_len, NULL, &p2p_ielen);
-	if (p2p_ie != ie || p2p_ielen == 0)
-		return;
-
-	pos += 6;
-	while (pos-ie < ie_len) {
-		id = *pos;
-		len = get_unaligned_le16(pos+1);
-
-		DBG_8723A("%s ID:%u, LEN:%u\n", __func__, id, len);
-
-		pos+= (3+len);
-	}
-}
-
-/**
- * rtw_get_p2p_ie23a - Search P2P IE from a series of IEs
- * @in_ie: Address of IEs to search
- * @in_len: Length limit from in_ie
- * @p2p_ie: If not NULL and P2P IE is found, P2P IE will be copied to the
- *          buf starting from p2p_ie
- * @p2p_ielen: If not NULL and P2P IE is found, will set to the length of
- *             the entire P2P IE
- *
- * Returns: The address of the P2P IE found, or NULL
- */
-u8 *rtw_get_p2p_ie23a(u8 *in_ie, int in_len, u8 *p2p_ie, uint *p2p_ielen)
-{
-	uint cnt = 0;
-	u8 *p2p_ie_ptr;
-	u8 eid, p2p_oui[4]={0x50, 0x6F, 0x9A, 0x09};
-
-	if (p2p_ielen)
-		*p2p_ielen = 0;
-
-	while (cnt<in_len) {
-		eid = in_ie[cnt];
-		if ((in_len < 0) || (cnt > MAX_IE_SZ)) {
-			dump_stack();
-			return NULL;
-		}
-		if ((eid == _VENDOR_SPECIFIC_IE_) &&
-		    !memcmp(&in_ie[cnt + 2], p2p_oui, 4)) {
-			p2p_ie_ptr = in_ie + cnt;
-
-			if (p2p_ie != NULL) {
-				memcpy(p2p_ie, &in_ie[cnt],
-				       in_ie[cnt + 1] + 2);
-			}
-
-			if (p2p_ielen != NULL) {
-				*p2p_ielen = in_ie[cnt + 1] + 2;
-			}
-
-			return p2p_ie_ptr;
-
-			break;
-		} else {
-			cnt += in_ie[cnt + 1] + 2; /* goto next */
-		}
-	}
-
-	return NULL;
-}
-
-/**
- * rtw_get_p2p_attr23a - Search a specific P2P attribute from a given P2P IE
- * @p2p_ie: Address of P2P IE to search
- * @p2p_ielen: Length limit from p2p_ie
- * @target_attr_id: The attribute ID of P2P attribute to search
- * @buf_attr: If not NULL and the P2P attribute is found, P2P attribute will
- *            be copied to the buf starting from buf_attr
- * @len_attr: If not NULL and the P2P attribute is found, will set to the
- *            length of the entire P2P attribute
- *
- * Returns: the address of the specific WPS attribute found, or NULL
- */
-u8 *rtw_get_p2p_attr23a(u8 *p2p_ie, uint p2p_ielen, u8 target_attr_id,
-		     u8 *buf_attr, u32 *len_attr)
-{
-	u8 *attr_ptr = NULL;
-	u8 *target_attr_ptr = NULL;
-	u8 p2p_oui[4]={0x50, 0x6F, 0x9A, 0x09};
-
-	if (len_attr)
-		*len_attr = 0;
-
-	if (!p2p_ie || (p2p_ie[0] != _VENDOR_SPECIFIC_IE_) ||
-	    memcmp(p2p_ie + 2, p2p_oui, 4)) {
-		return attr_ptr;
-	}
-
-	/*  6 = 1(Element ID) + 1(Length) + 3 (OUI) + 1(OUI Type) */
-	attr_ptr = p2p_ie + 6; /* goto first attr */
-
-	while (attr_ptr - p2p_ie < p2p_ielen) {
-		/*  3 = 1(Attribute ID) + 2(Length) */
-		u8 attr_id = *attr_ptr;
-		u16 attr_data_len = get_unaligned_le16(attr_ptr + 1);
-		u16 attr_len = attr_data_len + 3;
-
-		/* DBG_8723A("%s attr_ptr:%p, id:%u, length:%u\n", __func__, attr_ptr, attr_id, attr_data_len); */
-		if (attr_id == target_attr_id) {
-			target_attr_ptr = attr_ptr;
-
-			if (buf_attr)
-				memcpy(buf_attr, attr_ptr, attr_len);
-
-			if (len_attr)
-				*len_attr = attr_len;
-
-			break;
-		} else {
-			attr_ptr += attr_len; /* goto next */
-		}
-	}
-
-	return target_attr_ptr;
-}
-
-/**
- * rtw_get_p2p_attr23a_content - Search a specific P2P attribute content from
- * a given P2P IE
- * @p2p_ie: Address of P2P IE to search
- * @p2p_ielen: Length limit from p2p_ie
- * @target_attr_id: The attribute ID of P2P attribute to search
- * @buf_content: If not NULL and the P2P attribute is found, P2P attribute
- *               content will be copied to the buf starting from buf_content
- * @len_content: If not NULL and the P2P attribute is found, will set to the
- *               length of the P2P attribute content
- *
- * Returns: the address of the specific P2P attribute content found, or NULL
- */
-u8 *rtw_get_p2p_attr23a_content(u8 *p2p_ie, uint p2p_ielen, u8 target_attr_id,
-			     u8 *buf_content, uint *len_content)
-{
-	u8 *attr_ptr;
-	u32 attr_len;
-
-	if (len_content)
-		*len_content = 0;
-
-	attr_ptr = rtw_get_p2p_attr23a(p2p_ie, p2p_ielen, target_attr_id,
-				    NULL, &attr_len);
-
-	if (attr_ptr && attr_len) {
-		if (buf_content)
-			memcpy(buf_content, attr_ptr + 3, attr_len - 3);
-
-		if (len_content)
-			*len_content = attr_len - 3;
-
-		return attr_ptr+3;
-	}
-
-	return NULL;
-}
-
-u32 rtw_set_p2p_attr_content23a(u8 *pbuf, u8 attr_id, u16 attr_len, u8 *pdata_attr)
-{
-	u32 a_len;
-
-	*pbuf = attr_id;
-
-	/* u16*)(pbuf + 1) = cpu_to_le16(attr_len); */
-	put_unaligned_le16(attr_len, pbuf + 1);
-
-	if (pdata_attr)
-		memcpy(pbuf + 3, pdata_attr, attr_len);
-
-	a_len = attr_len + 3;
-
-	return a_len;
-}
-
-static uint rtw_p2p_attr_remove(u8 *ie, uint ielen_ori, u8 attr_id)
-{
-	u8 *target_attr;
-	u32 target_attr_len;
-	uint ielen = ielen_ori;
-
-	while(1) {
-		target_attr = rtw_get_p2p_attr23a(ie, ielen, attr_id, NULL,
-					     &target_attr_len);
-		if (target_attr && target_attr_len) {
-			u8 *next_attr = target_attr+target_attr_len;
-			uint remain_len = ielen-(next_attr-ie);
-			/* dump_ies23a(ie, ielen); */
-
-			memset(target_attr, 0, target_attr_len);
-			memcpy(target_attr, next_attr, remain_len);
-			memset(target_attr+remain_len, 0, target_attr_len);
-			*(ie + 1) -= target_attr_len;
-			ielen -= target_attr_len;
-		} else {
-			/* if (index>0) */
-			/*	dump_ies23a(ie, ielen); */
-			break;
-		}
-	}
-
-	return ielen;
-}
-
-void rtw_wlan_bssid_ex_remove_p2p_attr23a(struct wlan_bssid_ex *bss_ex, u8 attr_id)
-{
-	u8 *p2p_ie;
-	uint p2p_ielen, p2p_ielen_ori;
-
-	if ((p2p_ie = rtw_get_p2p_ie23a(bss_ex->IEs + _FIXED_IE_LENGTH_,
-				     bss_ex->IELength - _FIXED_IE_LENGTH_,
-				     NULL, &p2p_ielen_ori))) {
-		p2p_ielen = rtw_p2p_attr_remove(p2p_ie, p2p_ielen_ori, attr_id);
-		if (p2p_ielen != p2p_ielen_ori) {
-			u8 *next_ie_ori = p2p_ie+p2p_ielen_ori;
-			u8 *next_ie = p2p_ie+p2p_ielen;
-			uint remain_len;
-			remain_len = bss_ex->IELength-(next_ie_ori-bss_ex->IEs);
-
-			memcpy(next_ie, next_ie_ori, remain_len);
-			memset(next_ie+remain_len, 0, p2p_ielen_ori-p2p_ielen);
-			bss_ex->IELength -= p2p_ielen_ori-p2p_ielen;
-		}
-	}
-}
-
-#endif /* CONFIG_8723AU_P2P */
-
-#ifdef CONFIG_8723AU_P2P
-int rtw_get_wfd_ie(u8 *in_ie, int in_len, u8 *wfd_ie, uint *wfd_ielen)
-{
-	int match;
-	const u8 *ie;
-
-	match = 0;
-
-	if (in_len < 0)
-		return match;
-
-	ie = cfg80211_find_vendor_ie(0x506F9A, 0x0A, in_ie, in_len);
-	if (ie && (ie[1] <= (MAX_WFD_IE_LEN - 2))) {
-		if (wfd_ie) {
-			*wfd_ielen = ie[1] + 2;
-			memcpy(wfd_ie, ie, ie[1] + 2);
-		} else
-			if (wfd_ielen)
-				*wfd_ielen = 0;
-
-		match = 1;
-	}
-
-	return match;
-}
-
-/*	attr_content: The output buffer, contains the "body field" of
-	WFD attribute. */
-/*	attr_contentlen: The data length of the "body field" of WFD
-	attribute. */
-int rtw_get_wfd_attr_content(u8 *wfd_ie, uint wfd_ielen, u8 target_attr_id,
-			     u8 *attr_content, uint *attr_contentlen)
-{
-	int match;
-	uint cnt = 0;
-	u8 attr_id, wfd_oui[4] = {0x50, 0x6F, 0x9A, 0x0A};
-
-	match = false;
-
-	if ((wfd_ie[0] != _VENDOR_SPECIFIC_IE_) ||
-	    memcmp(wfd_ie + 2, wfd_oui, 4)) {
-		return match;
-	}
-
-	/*	1 (WFD IE) + 1 (Length) + 3 (OUI) + 1 (OUI Type) */
-	cnt = 6;
-	while (cnt < wfd_ielen) {
-		u16 attrlen = get_unaligned_be16(wfd_ie + cnt + 1);
-
-		attr_id = wfd_ie[cnt];
-		if (attr_id == target_attr_id) {
-			/*	3 -> 1 byte for attribute ID field, 2
-				bytes for length field */
-			if (attr_content)
-				memcpy(attr_content, &wfd_ie[cnt + 3], attrlen);
-
-			if (attr_contentlen)
-				*attr_contentlen = attrlen;
-
-			cnt += attrlen + 3;
-
-			match = true;
-			break;
-		} else {
-			cnt += attrlen + 3; /* goto next */
-		}
-	}
-
-	return match;
-}
-#endif /*  CONFIG_8723AU_P2P */
-
-/* Baron adds to avoid FreeBSD warning */
-int ieee80211_is_empty_essid23a(const char *essid, int essid_len)
-{
-	/* Single white space is for Linksys APs */
-	if (essid_len == 1 && essid[0] == ' ')
-		return 1;
-
-	/* Otherwise, if the entire essid is 0, we assume it is hidden */
-	while (essid_len) {
-		essid_len--;
-		if (essid[essid_len] != '\0')
-			return 0;
-	}
-
-	return 1;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int rtw_get_cipher_info(struct wlan_network *pnetwork)
 {
 	const u8 *pbuf;
diff -puN drivers/staging/rtl8723au/core/rtw_mlme_ext.c~linux-next-git-rejects drivers/staging/rtl8723au/core/rtw_mlme_ext.c
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c~linux-next-git-rejects
+++ a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -1287,20 +1287,7 @@ OnAssocReq23a(struct rtw_adapter *padapt
 	const u8 *pos, *p, *wpa_ie, *wps_ie;
 	u8 *pframe = skb->data;
 	uint pkt_len = skb->len;
-<<<<<<< HEAD
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 frame_control;
-#ifdef CONFIG_8723AU_P2P
-	struct wifidirect_info *pwdinfo = &padapter->wdinfo;
-	u8 p2p_status_code = P2P_STATUS_SUCCESS;
-	u8 *p2pie;
-	u32 p2pielen = 0;
-	u8	wfd_ie[MAX_WFD_IE_LEN] = { 0x00 };
-	u32	wfd_ielen = 0;
-#endif /* CONFIG_8723AU_P2P */
-=======
 	int r;
->>>>>>> linux-next/akpm-base
 
 	if ((pmlmeinfo->state & 0x03) != WIFI_FW_AP_STATE)
 		return _FAIL;
diff -puN drivers/staging/rtl8723au/core/rtw_wlan_util.c~linux-next-git-rejects drivers/staging/rtl8723au/core/rtw_wlan_util.c
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c~linux-next-git-rejects
+++ a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -498,35 +498,6 @@ void flush_all_cam_entry23a(struct rtw_a
 	memset((u8 *)(pmlmeinfo->FW_sta_info), 0, sizeof(pmlmeinfo->FW_sta_info));
 }
 
-<<<<<<< HEAD
-#if defined(CONFIG_8723AU_P2P) && defined(CONFIG_8723AU_P2P)
-int WFD_info_handler(struct rtw_adapter *padapter, struct ndis_802_11_var_ies *	pIE)
-{
-	struct wifidirect_info	*pwdinfo;
-	u8	wfd_ie[MAX_WFD_IE_LEN] = {0x00};
-	u32	wfd_ielen = 0;
-
-	pwdinfo = &padapter->wdinfo;
-	if (rtw_get_wfd_ie((u8 *) pIE, pIE->Length, wfd_ie, &wfd_ielen)) {
-		u8	attr_content[ 10 ] = { 0x00 };
-		u32	attr_contentlen = 0;
-
-		DBG_8723A("[%s] Found WFD IE\n", __func__);
-		rtw_get_wfd_attr_content(wfd_ie, wfd_ielen, WFD_ATTR_DEVICE_INFO, attr_content, &attr_contentlen);
-		if (attr_contentlen) {
-			pwdinfo->wfd_info->peer_rtsp_ctrlport = get_unaligned_be16(attr_content + 2);
-			DBG_8723A("[%s] Peer PORT NUM = %d\n", __func__, pwdinfo->wfd_info->peer_rtsp_ctrlport);
-			return true;
-		}
-	} else {
-		DBG_8723A("[%s] NO WFD IE\n", __func__);
-	}
-	return _FAIL;
-}
-#endif
-
-=======
->>>>>>> linux-next/akpm-base
 int WMM_param_handler23a(struct rtw_adapter *padapter, struct ndis_802_11_var_ies *	pIE)
 {
 	/* struct registry_priv	*pregpriv = &padapter->registrypriv; */
diff -puN fs/ext4/extents.c~linux-next-git-rejects fs/ext4/extents.c
--- a/fs/ext4/extents.c~linux-next-git-rejects
+++ a/fs/ext4/extents.c
@@ -3319,11 +3319,7 @@ static int ext4_split_extent(handle_t *h
 				 (unsigned long) map->m_lblk);
 		return -EIO;
 	}
-<<<<<<< HEAD
-	uninitialized = ext4_ext_is_uninitialized(ex);
-=======
 	unwritten = ext4_ext_is_unwritten(ex);
->>>>>>> linux-next/akpm-base
 	split_flag1 = 0;
 
 	if (map->m_lblk >= ee_block) {
@@ -5266,16 +5262,6 @@ ext4_ext_shift_path_extents(struct ext4_
 
 			while (ex_start <= ex_last) {
 				le32_add_cpu(&ex_start->ee_block, -shift);
-<<<<<<< HEAD
-				/* Try to merge to the left. */
-				if ((ex_start >
-				     EXT_FIRST_EXTENT(path[depth].p_hdr)) &&
-				    ext4_ext_try_to_merge_right(inode,
-							path, ex_start - 1))
-					ex_last--;
-				else
-					ex_start++;
-=======
 				if (ex_start >
 					EXT_FIRST_EXTENT(path[depth].p_hdr)) {
 					if (ext4_ext_try_to_merge_right(inode,
@@ -5283,7 +5269,6 @@ ext4_ext_shift_path_extents(struct ext4_
 						ex_last--;
 				}
 				ex_start++;
->>>>>>> linux-next/akpm-base
 			}
 			err = ext4_ext_dirty(handle, inode, path + depth);
 			if (err)
@@ -5449,15 +5434,6 @@ int ext4_collapse_range(struct inode *in
 			return ret;
 	}
 
-<<<<<<< HEAD
-	/*
-	 * Need to round down offset to be aligned with page size boundary
-	 * for page size > block size.
-	 */
-	ioffset = round_down(offset, PAGE_SIZE);
-
-=======
->>>>>>> linux-next/akpm-base
 	/* Write out all dirty pages */
 	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
 					   LLONG_MAX);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-gupc-tweaks.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

